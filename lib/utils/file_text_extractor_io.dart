import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:file_selector/file_selector.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:xml/xml.dart';

import 'file_text_extractor_types.dart';

Future<FileExtractionResult> extractFileTextImpl(XFile file) async {
  final String extension = p.extension(file.name).toLowerCase();

  try {
    if (_plainTextExtensions.contains(extension)) {
      final List<int> bytes = await file.readAsBytes();
      final String decoded = utf8.decode(bytes, allowMalformed: true);
      return decoded.trim().isEmpty
          ? FileExtractionResult.failure('No readable text found in ${file.name}.')
          : FileExtractionResult.success(decoded);
    }

    if (extension == '.pdf') {
      final String? text = await _extractPdfText(file);
      return _resultFromText(text, file.name);
    }

    if (extension == '.docx') {
      final String? text = await _extractDocxText(file);
      return _resultFromText(text, file.name);
    }

    if (_imageExtensions.contains(extension)) {
      final String? text = await _extractImageText(file);
      return _resultFromText(text, file.name);
    }

    if (extension == '.doc') {
      return FileExtractionResult.failure(
        'Word .doc files are not supported. Convert the file to .docx and try again.',
      );
    }

    return FileExtractionResult.failure(
      'Files of type "$extension" are not supported yet.',
    );
  } catch (error) {
    return FileExtractionResult.failure('Unable to read ${file.name}. $error');
  }
}

Future<String?> _extractPdfText(XFile file) async {
  final List<int> bytes = await file.readAsBytes();
  final PdfDocument document = PdfDocument(inputBytes: bytes);
  try {
    final PdfTextExtractor extractor = PdfTextExtractor(document);
    return extractor.extractText();
  } finally {
    document.dispose();
  }
}

Future<String?> _extractDocxText(XFile file) async {
  final List<int> bytes = await file.readAsBytes();
  final Archive archive = ZipDecoder().decodeBytes(bytes, verify: true);
  ArchiveFile? documentFile;
  for (final ArchiveFile entry in archive.files) {
    if (entry.name == 'word/document.xml') {
      documentFile = entry;
      break;
    }
  }

  if (documentFile == null) {
    return null;
  }

  final List<int> contentBytes = documentFile.content is List<int>
      ? List<int>.from(documentFile.content as List<int>)
      : (documentFile.content as Uint8List?)?.toList() ?? <int>[];
  if (contentBytes.isEmpty) {
    return null;
  }

  final String xmlString = utf8.decode(contentBytes, allowMalformed: true);
  final XmlDocument xmlDocument = XmlDocument.parse(xmlString);
  final Iterable<XmlElement> paragraphs = xmlDocument.findAllElements('w:p');
  final StringBuffer buffer = StringBuffer();

  for (final XmlElement paragraph in paragraphs) {
    final Iterable<XmlElement> textNodes = paragraph.findAllElements('w:t');
    final String paragraphText = textNodes.map((XmlElement node) => node.innerText).join('');
    if (paragraphText.trim().isEmpty) {
      continue;
    }
    if (buffer.isNotEmpty) {
      buffer.writeln();
    }
    buffer.write(paragraphText);
  }

  return buffer.toString();
}

Future<String?> _extractImageText(XFile file) async {
  String path = file.path;
  File? tempFile;

  if (path.isEmpty) {
    final Directory temporaryDirectory = await getTemporaryDirectory();
    final String tempPath = p.join(
      temporaryDirectory.path,
      'sylo_${DateTime.now().millisecondsSinceEpoch}_${file.name}',
    );
    tempFile = File(tempPath);
    final List<int> bytes = await file.readAsBytes();
    await tempFile.writeAsBytes(bytes, flush: true);
    path = tempPath;
  }

  final InputImage inputImage = InputImage.fromFilePath(path);
  final TextRecognizer recognizer = TextRecognizer();

  try {
    final RecognizedText recognizedText = await recognizer.processImage(inputImage);
    return recognizedText.text;
  } finally {
    await recognizer.close();
    if (tempFile != null && tempFile.existsSync()) {
      unawaited(tempFile.delete());
    }
  }
}

FileExtractionResult _resultFromText(String? text, String fileName) {
  if (text == null || text.trim().isEmpty) {
    return FileExtractionResult.failure('No readable text found in $fileName.');
  }
  return FileExtractionResult.success(text);
}

const Set<String> _plainTextExtensions = <String>{
  '.txt',
  '.md',
  '.csv',
  '.json',
  '.html',
  '.htm',
  '.rtf',
  '.tex',
};

const Set<String> _imageExtensions = <String>{
  '.png',
  '.jpg',
  '.jpeg',
  '.gif',
  '.bmp',
  '.tif',
  '.tiff',
};
