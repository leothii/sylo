import 'package:file_selector/file_selector.dart';

import 'file_text_extractor_types.dart';

Future<FileExtractionResult> extractFileTextImpl(XFile file) async {
  return FileExtractionResult.failure(
    'File extraction is not supported on this platform yet.',
  );
}
