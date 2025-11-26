import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/env.dart';

class SpotifySession {
  const SpotifySession({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresAt,
    required this.scope,
    this.displayName,
    this.userId,
  });

  final String accessToken;
  final String refreshToken;
  final DateTime expiresAt;
  final String scope;
  final String? displayName;
  final String? userId;

  bool get isExpired {
    final DateTime grace = expiresAt.subtract(const Duration(seconds: 45));
    return DateTime.now().isAfter(grace);
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'expiresAt': expiresAt.toIso8601String(),
      'scope': scope,
      'displayName': displayName,
      'userId': userId,
    };
  }

  factory SpotifySession.fromJson(Map<String, dynamic> json) {
    return SpotifySession(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String? ?? '',
      expiresAt: DateTime.parse(json['expiresAt'] as String),
      scope: json['scope'] as String? ?? '',
      displayName: json['displayName'] as String?,
      userId: json['userId'] as String?,
    );
  }

  SpotifySession copyWith({
    String? accessToken,
    String? refreshToken,
    DateTime? expiresAt,
    String? scope,
    String? displayName,
    String? userId,
  }) {
    return SpotifySession(
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      expiresAt: expiresAt ?? this.expiresAt,
      scope: scope ?? this.scope,
      displayName: displayName ?? this.displayName,
      userId: userId ?? this.userId,
    );
  }
}

class SpotifyService {
  SpotifyService._();

  static final SpotifyService instance = SpotifyService._();
  static const String _prefsKey = 'spotify.session.v1';
  static const List<String> _defaultScopes = <String>[
    'user-read-email',
    'user-read-private',
  ];

  final ValueNotifier<SpotifySession?> session = ValueNotifier<SpotifySession?>(null);

  bool _loaded = false;

  Future<void> ensureInitialized() async {
    if (_loaded) {
      return;
    }
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? stored = prefs.getString(_prefsKey);
    if (stored != null) {
      try {
        final Map<String, dynamic> json = jsonDecode(stored) as Map<String, dynamic>;
        session.value = SpotifySession.fromJson(json);
      } catch (_) {
        await prefs.remove(_prefsKey);
      }
    }
    _loaded = true;
  }

  Future<SpotifySession> connect() async {
    await ensureInitialized();

    final String clientId = Env.requireSpotifyClientId();
    final String redirectUri = Env.requireSpotifyRedirectUri();
    final String callbackScheme = Uri.parse(redirectUri).scheme;
    if (callbackScheme.isEmpty) {
      throw StateError('Invalid Spotify redirect URI. Ensure it includes a URL scheme.');
    }

    final String verifier = _generateCodeVerifier();
    final String challenge = _codeChallenge(verifier);
    final String state = _randomString(length: 16);

    final Uri authorizeUrl = Uri.https(
      'accounts.spotify.com',
      '/authorize',
      <String, String>{
        'client_id': clientId,
        'response_type': 'code',
        'redirect_uri': redirectUri,
        'scope': _defaultScopes.join(' '),
        'code_challenge_method': 'S256',
        'code_challenge': challenge,
        'state': state,
        'show_dialog': 'false',
      },
    );

    String result;
    try {
      result = await FlutterWebAuth2.authenticate(
        url: authorizeUrl.toString(),
        callbackUrlScheme: callbackScheme,
      );
    } on PlatformException catch (error) {
      debugPrint('Spotify auth platform exception: code=${error.code} message=${error.message} details=${error.details}');
      if (error.code == 'CANCELED' || error.code == 'USER_CANCELED') {
        throw StateError('Spotify sign-in was cancelled.');
      }
      throw StateError('Spotify sign-in failed: ${error.message ?? error.code}.');
    }

    debugPrint('Spotify auth callback: $result');

    final Uri resultUri = Uri.parse(result);
    if (resultUri.queryParameters['state'] != state) {
      debugPrint('Spotify auth state mismatch. Expected $state got ${resultUri.queryParameters['state']}');
      throw StateError('Spotify authorization failed due to mismatched state.');
    }

    final String? authorizationCode = resultUri.queryParameters['code'];
    if (authorizationCode == null || authorizationCode.isEmpty) {
      final String? errorParam = resultUri.queryParameters['error'];
      if (errorParam != null) {
        debugPrint('Spotify authorization returned error: $errorParam');
      }
      throw StateError(
        errorParam == null || errorParam.isEmpty
            ? 'Spotify authorization did not return a code.'
            : 'Spotify authorization failed: $errorParam.',
      );
    }

    final SpotifySession session = await _exchangeCode(
      code: authorizationCode,
      verifier: verifier,
      redirectUri: redirectUri,
      clientId: clientId,
    );

    final SpotifySession sessionWithProfile = await _attachProfile(session);
    await _storeSession(sessionWithProfile);
    this.session.value = sessionWithProfile;
    return sessionWithProfile;
  }

  Future<void> disconnect() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_prefsKey);
    session.value = null;
  }

  Future<String?> ensureAccessToken() async {
    await ensureInitialized();
    final SpotifySession? current = session.value;
    if (current == null) {
      return null;
    }
    if (!current.isExpired) {
      return current.accessToken;
    }
    if (current.refreshToken.isEmpty) {
      return current.accessToken;
    }

    final SpotifySession refreshed = await _refreshSession(current);
    await _storeSession(refreshed);
    session.value = refreshed;
    return refreshed.accessToken;
  }

  Future<SpotifySession> _exchangeCode({
    required String code,
    required String verifier,
    required String redirectUri,
    required String clientId,
  }) async {
    final Uri tokenUri = Uri.https('accounts.spotify.com', '/api/token');
    final http.Response response = await http.post(
      tokenUri,
      headers: const <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: <String, String>{
        'grant_type': 'authorization_code',
        'code': code,
        'redirect_uri': redirectUri,
        'client_id': clientId,
        'code_verifier': verifier,
      },
    );

    final Map<String, dynamic> body = _decodeResponse(response);
    if (response.statusCode != 200) {
      final String fallbackMessage = _extractError(body) ?? 'Spotify token exchange failed.';
      debugPrint('Spotify token exchange error: ${response.statusCode} ${response.body}');
      throw StateError(fallbackMessage);
    }

    final String? accessToken = body['access_token'] as String?;
    if (accessToken == null || accessToken.isEmpty) {
      throw StateError('Spotify token exchange did not return an access token.');
    }

    final int expiresIn = (body['expires_in'] as num?)?.round() ?? 3600;
    final DateTime expiresAt = DateTime.now().add(Duration(seconds: expiresIn));

    final String refreshToken = (body['refresh_token'] as String?) ?? '';
    final String scope = (body['scope'] as String?) ?? _defaultScopes.join(' ');

    return SpotifySession(
      accessToken: accessToken,
      refreshToken: refreshToken,
      expiresAt: expiresAt,
      scope: scope,
    );
  }

  Future<SpotifySession> _refreshSession(SpotifySession session) async {
    final String clientId = Env.requireSpotifyClientId();
    if (session.refreshToken.isEmpty) {
      return session;
    }

    final Uri tokenUri = Uri.https('accounts.spotify.com', '/api/token');
    final http.Response response = await http.post(
      tokenUri,
      headers: const <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: <String, String>{
        'grant_type': 'refresh_token',
        'refresh_token': session.refreshToken,
        'client_id': clientId,
      },
    );

    final Map<String, dynamic> body = _decodeResponse(response);
    if (response.statusCode != 200) {
      final String fallbackMessage = _extractError(body) ?? 'Spotify token refresh failed.';
      debugPrint('Spotify token refresh error: ${response.statusCode} ${response.body}');
      throw StateError(fallbackMessage);
    }

    final String? accessToken = body['access_token'] as String?;
    if (accessToken == null || accessToken.isEmpty) {
      throw StateError('Spotify token refresh did not return an access token.');
    }

    final int expiresIn = (body['expires_in'] as num?)?.round() ?? 3600;
    final DateTime expiresAt = DateTime.now().add(Duration(seconds: expiresIn));
    final String scope = (body['scope'] as String?) ?? session.scope;
    final String refreshToken = (body['refresh_token'] as String?) ?? session.refreshToken;

    final SpotifySession updated = session.copyWith(
      accessToken: accessToken,
      refreshToken: refreshToken,
      expiresAt: expiresAt,
      scope: scope,
    );

    return await _attachProfile(updated);
  }

  Future<SpotifySession> _attachProfile(SpotifySession session) async {
    try {
      final http.Response response = await http.get(
        Uri.parse('https://api.spotify.com/v1/me'),
        headers: <String, String>{
          'Authorization': 'Bearer ${session.accessToken}',
        },
      );

      if (response.statusCode != 200) {
        return session;
      }

      final Map<String, dynamic> body = jsonDecode(response.body) as Map<String, dynamic>;
      return session.copyWith(
        displayName: body['display_name'] as String?,
        userId: body['id'] as String?,
      );
    } catch (_) {
      return session;
    }
  }

  Future<void> _storeSession(SpotifySession session) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, jsonEncode(session.toJson()));
  }

  Map<String, dynamic> _decodeResponse(http.Response response) {
    try {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } catch (_) {
      return <String, dynamic>{'error_description': response.body};
    }
  }

  String? _extractError(Map<String, dynamic> body) {
    final Object? description = body['error_description'] ?? body['error'];
    if (description == null) {
      return null;
    }
    return description.toString();
  }

  String _generateCodeVerifier() {
    return _randomString(length: 64);
  }

  String _codeChallenge(String verifier) {
    final List<int> bytes = utf8.encode(verifier);
    final Digest digest = sha256.convert(bytes);
    return base64UrlEncode(digest.bytes).replaceAll('=', '');
  }

  String _randomString({int length = 32}) {
    const String charset = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-._~';
    Random random;
    try {
      random = Random.secure();
    } on UnsupportedError {
      random = Random();
    }
    return List<String>.generate(length, (_) => charset[random.nextInt(charset.length)]).join();
  }
}
