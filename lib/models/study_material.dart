import 'dart:typed_data';

import 'attachment_payload.dart';

class GeminiLocalAttachment {
  const GeminiLocalAttachment({
    required this.bytes,
    required this.displayName,
    required this.mimeType,
  });

  final Uint8List bytes;
  final String displayName;
  final String mimeType;

  int get sizeBytes => bytes.lengthInBytes;
}

class StudyMaterial {
  StudyMaterial({
    String? text,
    List<GeminiLocalAttachment> attachments = const <GeminiLocalAttachment>[],
  })  : text = text?.trim(),
        attachments = List<GeminiLocalAttachment>.unmodifiable(attachments);

  final String? text;
  final List<GeminiLocalAttachment> attachments;

  bool get hasText => (text?.isNotEmpty ?? false);
  bool get hasAttachments => attachments.isNotEmpty;
  bool get isEmpty => !hasText && !hasAttachments;
}

class PreparedStudyMaterial {
  PreparedStudyMaterial({
    String? text,
    List<GeminiFileAttachment> attachments = const <GeminiFileAttachment>[],
  })  : text = text?.trim(),
        attachments = List<GeminiFileAttachment>.unmodifiable(attachments);

  final String? text;
  final List<GeminiFileAttachment> attachments;

  bool get hasText => (text?.isNotEmpty ?? false);
  bool get hasAttachments => attachments.isNotEmpty;
  bool get isEmpty => !hasText && !hasAttachments;
}
