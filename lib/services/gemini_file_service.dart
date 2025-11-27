import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import '../models/attachment_payload.dart';
import '../models/study_material.dart';
import '../utils/env.dart';

class GeminiFileService {
  GeminiFileService._({http.Client? httpClient})
      : _client = httpClient ?? http.Client();

  static final GeminiFileService instance = GeminiFileService._();

  final http.Client _client;

  Future<List<GeminiFileAttachment>> uploadAll(
    List<GeminiLocalAttachment> attachments,
  ) async {
    if (attachments.isEmpty) {
      return const <GeminiFileAttachment>[];
    }

    final List<GeminiFileAttachment> results = <GeminiFileAttachment>[];
    for (final GeminiLocalAttachment attachment in attachments) {
      results.add(await upload(attachment));
    }
    return results;
  }

  Future<GeminiFileAttachment> upload(GeminiLocalAttachment attachment) async {
    final Uri uri = Uri.https(
      'generativelanguage.googleapis.com',
      '/upload/v1beta/files',
      <String, String>{'key': Env.requireGeminiKey()},
    );

    final http.MultipartRequest request = http.MultipartRequest('POST', uri)
      ..fields['metadata'] = jsonEncode(<String, dynamic>{
        'file': <String, String>{
          'displayName': attachment.displayName,
        },
      })
      ..files.add(
        http.MultipartFile.fromBytes(
          'file',
          attachment.bytes,
          filename: attachment.displayName,
          contentType: MediaType.parse(attachment.mimeType),
        ),
      );

    final http.StreamedResponse response = await _client.send(request);
    final String rawBody = await response.stream.bytesToString();

    if (response.statusCode >= 400) {
      throw StateError(
        'Gemini file upload failed (${response.statusCode}). ${_safeMessageFromBody(rawBody)}',
      );
    }

    final Map<String, dynamic> decoded =
        jsonDecode(rawBody) as Map<String, dynamic>;
    final Map<String, dynamic>? fileJson =
        decoded['file'] as Map<String, dynamic>?;
    if (fileJson == null) {
      throw StateError(
        'Gemini upload response did not include file metadata.',
      );
    }

    GeminiFileAttachment attachmentInfo =
        GeminiFileAttachment.fromJson(fileJson);

    if (attachmentInfo.isActive) {
      return attachmentInfo;
    }

    attachmentInfo = await _pollUntilActive(attachmentInfo.resourceName);
    return attachmentInfo;
  }

  Future<GeminiFileAttachment> _pollUntilActive(
    String resourceName, {
    Duration timeout = const Duration(seconds: 45),
    Duration interval = const Duration(milliseconds: 600),
  }) async {
    final Stopwatch stopwatch = Stopwatch()..start();
    GeminiFileAttachment latest = await _fetch(resourceName);

    while (!latest.isActive) {
      if (latest.state.toUpperCase() == 'FAILED') {
        throw StateError(
          'Gemini failed to process "${latest.displayName}".',
        );
      }

      if (stopwatch.elapsed >= timeout) {
        throw StateError(
          'Timed out waiting for Gemini to process "${latest.displayName}".',
        );
      }

      await Future<void>.delayed(interval);
      latest = await _fetch(resourceName);
    }

    return latest;
  }

  Future<GeminiFileAttachment> _fetch(String resourceName) async {
    final Uri uri = Uri.https(
      'generativelanguage.googleapis.com',
      '/v1beta/$resourceName',
      <String, String>{'key': Env.requireGeminiKey()},
    );

    final http.Response response = await _client.get(
      uri,
      headers: const <String, String>{'Accept': 'application/json'},
    );

    if (response.statusCode >= 400) {
      throw StateError(
        'Gemini file lookup failed (${response.statusCode}). ${_safeMessageFromBody(response.body)}',
      );
    }

    final Map<String, dynamic> decoded =
        jsonDecode(response.body) as Map<String, dynamic>;
    return GeminiFileAttachment.fromJson(decoded);
  }

  String _safeMessageFromBody(String body) {
    if (body.isEmpty) {
      return '';
    }

    try {
      final Map<String, dynamic> decoded = jsonDecode(body) as Map<String, dynamic>;
      if (decoded['error'] is Map<String, dynamic>) {
        final Map<String, dynamic> error =
            decoded['error'] as Map<String, dynamic>;
        final String message = (error['message'] as String? ?? '').trim();
        if (message.isNotEmpty) {
          return message;
        }
      }
    } catch (_) {
      // Ignore parsing issues and fall back to raw response.
    }

    return body;
  }

  static String inferMimeType(String? extension) {
    switch (extension?.toLowerCase()) {
      case 'pdf':
        return 'application/pdf';
      case 'doc':
        return 'application/msword';
      case 'docx':
        return 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
      case 'txt':
        return 'text/plain';
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'mp3':
        return 'audio/mpeg';
      case 'wav':
        return 'audio/wav';
      case 'm4a':
        return 'audio/mp4';
      case 'ppt':
        return 'application/vnd.ms-powerpoint';
      case 'pptx':
        return 'application/vnd.openxmlformats-officedocument.presentationml.presentation';
      default:
        return 'application/octet-stream';
    }
  }
}
