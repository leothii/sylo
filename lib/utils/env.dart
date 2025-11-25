class Env {
  static const String grokKey = String.fromEnvironment('GROK_KEY');

  static bool get hasGrokKey {
    return grokKey.isNotEmpty;
  }

  static String requireGrokKey() {
    if (grokKey.isEmpty) {
      throw StateError(
        'GROK_KEY is missing. Run the app with --dart-define=GROK_KEY=your_grok_key.',
      );
    }
    return grokKey;
  }
}
