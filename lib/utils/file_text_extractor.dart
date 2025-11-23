import 'package:file_selector/file_selector.dart';

import 'file_text_extractor_types.dart';
import 'file_text_extractor_stub.dart'
    if (dart.library.io) 'file_text_extractor_io.dart';

export 'file_text_extractor_types.dart';

Future<FileExtractionResult> extractFileText(XFile file) {
  return extractFileTextImpl(file);
}
