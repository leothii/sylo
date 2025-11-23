// lib/config/env.dart

/// Centralized environment configuration for compile-time variables.
/// Values are pulled from Dart define flags, e.g.:
///   flutter run --dart-define=GEMINI_KEY=your_key
class Env {
  static const String geminiKey =
      String.fromEnvironment('GEMINI_KEY', defaultValue: '');
  static const String firebaseApiKey =
      String.fromEnvironment('FIREBASE_API_KEY', defaultValue: '');
  static const String backendBaseUrl =
      String.fromEnvironment('BACKEND_BASE_URL', defaultValue: '');
}
