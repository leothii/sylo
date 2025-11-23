class FileExtractionResult {
  FileExtractionResult._({this.text, this.error});

  factory FileExtractionResult.success(String text) {
    return FileExtractionResult._(text: text);
  }

  factory FileExtractionResult.failure(String message) {
    return FileExtractionResult._(error: message);
  }

  final String? text;
  final String? error;

  bool get hasText {
    return text != null && text!.trim().isNotEmpty;
  }
}
