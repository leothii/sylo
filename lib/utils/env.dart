class Env {
  static const String grokKey = String.fromEnvironment('GROK_KEY');
  static const String geminiKey = String.fromEnvironment('GEMINI_KEY');

  static bool get hasGrokKey {
    return grokKey.isNotEmpty;
  }

  static bool get hasGeminiKey {
    return geminiKey.isNotEmpty;
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
}
