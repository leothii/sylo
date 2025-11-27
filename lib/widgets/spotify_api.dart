import 'package:flutter/material.dart';

import '../services/spotify_service.dart';
import '../utils/env.dart';

class SpotifyApiOverlay extends StatefulWidget {
  const SpotifyApiOverlay({super.key});

  static const Color _colBackground = Color(0xFFF7DB9F);
  static const Color _colTextGrey = Color(0xFF7A8A8C);
  static const Color _colLinkRed = Color(0xFF8B3A3A);

  @override
  State<SpotifyApiOverlay> createState() => _SpotifyApiOverlayState();
}

enum _SpotifyConnectState { loading, success, error }

class _SpotifyApiOverlayState extends State<SpotifyApiOverlay> {
  final SpotifyService _spotifyService = SpotifyService.instance;
  _SpotifyConnectState _state = _SpotifyConnectState.loading;
  String? _errorMessage;
  SpotifySession? _session;

  @override
  void initState() {
    super.initState();
    _connect();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Center(
        child: Container(
          width: 240,
          constraints: const BoxConstraints(minHeight: 200, maxHeight: 230, maxWidth: 260),
          decoration: ShapeDecoration(
            color: SpotifyApiOverlay._colBackground,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            shadows: const [
              BoxShadow(
                color: Color(0x3F000000),
                blurRadius: 8,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            child: Column(
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 26,
                      height: 26,
                      child: Center(
                        child: const ImageIcon(
                          AssetImage('assets/icons/spotify.png'),
                          size: 30,
                          color: SpotifyApiOverlay._colTextGrey,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Text(
                        'connect to spotify',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: 'Quicksand',
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: SpotifyApiOverlay._colTextGrey,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).maybePop(false),
                      icon: const Icon(Icons.close, size: 20, color: SpotifyApiOverlay._colTextGrey),
                      splashRadius: 18,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: _buildStatusContent(),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                _buildFooter(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusContent() {
    switch (_state) {
      case _SpotifyConnectState.loading:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            SizedBox(
              width: 28,
              height: 28,
              child: CircularProgressIndicator(strokeWidth: 2.8, color: SpotifyApiOverlay._colTextGrey),
            ),
            SizedBox(height: 12),
            Text(
              'redirecting...',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Quicksand',
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: SpotifyApiOverlay._colTextGrey,
              ),
            ),
          ],
        );
      case _SpotifyConnectState.success:
        final String name = _session?.displayName?.trim().isNotEmpty == true
            ? _session!.displayName!
            : (_session?.userId ?? 'Spotify user');
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, color: Color(0xFF2E7D32), size: 38),
            const SizedBox(height: 12),
            Text(
              'Connected as\n$name',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Quicksand',
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: SpotifyApiOverlay._colTextGrey,
              ),
            ),
          ],
        );
      case _SpotifyConnectState.error:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, color: Color(0xFFB3261E), size: 30),
            const SizedBox(height: 12),
            Text(
              _errorMessage ?? 'Unable to connect to Spotify.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Quicksand',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: SpotifyApiOverlay._colTextGrey,
              ),
            ),
          ],
        );
    }
  }

  Widget _buildFooter() {
    switch (_state) {
      case _SpotifyConnectState.loading:
        return RichText(
          textAlign: TextAlign.center,
          text: const TextSpan(
            style: TextStyle(
              fontFamily: 'Quicksand',
              fontSize: 11,
              color: Color(0xFF333333),
            ),
            children: [
              TextSpan(text: "We are opening Spotify's login page."),
              TextSpan(text: '\n'),
              TextSpan(text: 'Stay on this screen to continue.'),
            ],
          ),
        );
      case _SpotifyConnectState.success:
        return TextButton(
          onPressed: () => Navigator.of(context).maybePop(true),
          child: const Text(
            'start listening',
            style: TextStyle(
              fontFamily: 'Quicksand',
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: SpotifyApiOverlay._colLinkRed,
            ),
          ),
        );
      case _SpotifyConnectState.error:
        return TextButton(
          onPressed: _connect,
          child: const Text(
            'try again',
            style: TextStyle(
              fontFamily: 'Quicksand',
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: SpotifyApiOverlay._colLinkRed,
            ),
          ),
        );
    }
  }

  Future<void> _connect() async {
    if (!Env.hasSpotifyCredentials) {
      setState(() {
        _state = _SpotifyConnectState.error;
        _errorMessage =
            'Spotify is not configured. Provide SPOTIFY_CLIENT_ID and SPOTIFY_REDIRECT_URI.';
      });
      return;
    }

    setState(() {
      _state = _SpotifyConnectState.loading;
      _errorMessage = null;
      _session = null;
    });

    try {
      final SpotifySession session = await _spotifyService.connect();
      if (!mounted) return;
      setState(() {
        _session = session;
        _state = _SpotifyConnectState.success;
      });
    } on StateError catch (error) {
      if (!mounted) return;
      setState(() {
        _state = _SpotifyConnectState.error;
        _errorMessage = error.message;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _state = _SpotifyConnectState.error;
        _errorMessage = 'Unable to connect to Spotify. Please try again.';
      });
    }
  }
}
