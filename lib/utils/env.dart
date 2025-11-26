class Env {
  static const String grokKey = String.fromEnvironment('GROK_KEY');
  static const String geminiKey = String.fromEnvironment('GEMINI_KEY');
  static const String spotifyClientId = String.fromEnvironment('SPOTIFY_CLIENT_ID');
  static const String spotifyRedirectUri = String.fromEnvironment('SPOTIFY_REDIRECT_URI');

  static bool get hasGrokKey {
    return grokKey.isNotEmpty;
  }

  static bool get hasGeminiKey {
    return geminiKey.isNotEmpty;
  }

  static bool get hasSpotifyCredentials {
    return spotifyClientId.isNotEmpty && spotifyRedirectUri.isNotEmpty;
  }

  static String requireGrokKey() {
    if (grokKey.isEmpty) {
      throw StateError(
        'GROK_KEY is missing. Run the app with --dart-define=GROK_KEY=your_grok_key.',
      );
    }
    return grokKey;
  }

  static String requireGeminiKey() {
    if (geminiKey.isEmpty) {
      throw StateError(
        'GEMINI_KEY is missing. Run the app with --dart-define=GEMINI_KEY=your_gemini_key.',
      );
    }
    return geminiKey;
  }

  static String requireSpotifyClientId() {
    if (spotifyClientId.isEmpty) {
      throw StateError(
        'SPOTIFY_CLIENT_ID is missing. Run the app with --dart-define=SPOTIFY_CLIENT_ID=your_client_id.',
      );
    }
    return spotifyClientId;
  }

  static String requireSpotifyRedirectUri() {
    if (spotifyRedirectUri.isEmpty) {
      throw StateError(
        'SPOTIFY_REDIRECT_URI is missing. Run the app with --dart-define=SPOTIFY_REDIRECT_URI=your_redirect_uri.',
      );
    }
    return spotifyRedirectUri;
  }
}
