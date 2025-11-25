import 'dart:convert';

import 'package:google_generative_ai/google_generative_ai.dart';

import '../utils/env.dart';

class StudySummary {
  const StudySummary({
    required this.title,
    required this.overview,
    required this.keyPoints,
    required this.studyTips,
    required this.followUp,
  });

  final String title;
  final String overview;
  final List<String> keyPoints;
  final List<String> studyTips;
  final List<String> followUp;

  factory StudySummary.fromJson(Map<String, dynamic> json) {
    List<String> toList(dynamic value) {
      if (value is List) {
        return value.whereType<String>().map((String item) => item.trim()).where((String item) => item.isNotEmpty).toList();
      }
      return <String>[];
    }

    return StudySummary(
      title: (json['title'] as String?)?.trim() ?? 'Study Brief',
      overview: (json['overview'] as String?)?.trim() ?? '',
      keyPoints: toList(json['keyPoints']),
      studyTips: toList(json['studyTips']),
      followUp: toList(json['followUp']),
    );
  }
}

class AIService {
  AIService()
      : _model = GenerativeModel(
          model: 'gemini-2.0-flash',
          apiKey: Env.requireGeminiKey(),
          generationConfig: GenerationConfig(
            responseMimeType: 'application/json',
            temperature: 0.3,
          ),
        );

  final GenerativeModel _model;

  Future<StudySummary> summarize(String content) async {
    final String trimmed = _normalizeContent(content);
    if (trimmed.isEmpty) {
      throw StateError('There is no study text to analyze.');
    }

    final String prompt = '''
You are Sylo, a warm and precise academic study coach.
Create a concise study brief for the learner using the provided material.
Respond with JSON that matches this schema:
{
  "title": string,
  "overview": string,
  "keyPoints": [string, ...],
  "studyTips": [string, ...],
  "followUp": [string, ...]
}
Keep language accessible, avoid markdown bullets inside strings, and rely only on supplied content.

CONTENT:
$trimmed
''';

    final GenerateContentResponse response;
    try {
      response =
          await _model.generateContent(<Content>[Content.text(prompt)]);
    } on GenerativeAIException catch (error) {
      final String details = error.message.trim();
      final String message = details.isNotEmpty
          ? details
          : 'Gemini rejected the request.';
      throw StateError(message);
    } catch (error) {
      throw StateError('Gemini request failed: $error');
    }

    final String raw = response.text?.trim() ?? '';
    if (raw.isEmpty) {
      throw StateError('Gemini did not return any summary.');
    }

    final String jsonPayload = _extractJson(raw);

    try {
      final Map<String, dynamic> data =
          jsonDecode(jsonPayload) as Map<String, dynamic>;
      return StudySummary.fromJson(data);
    } on FormatException catch (error) {
      throw StateError('Unable to parse summary. ${error.message}');
    }
  }

  String _extractJson(String text) {
    final String sanitized =
        text.replaceAll(RegExp(r'```json|```', multiLine: true), '').trim();
    final int start = sanitized.indexOf('{');
    final int end = sanitized.lastIndexOf('}');
    if (start == -1 || end == -1 || end <= start) {
      return sanitized;
    }
    return sanitized.substring(start, end + 1);
  }

  String _normalizeContent(String input) {
    final String withoutTabs = input.replaceAll(RegExp(r'[\t]+'), ' ');
    final Iterable<String> lines = withoutTabs
        .split(RegExp(r'\r?\n'))
        .map((String line) => line.trim())
        .where((String line) => line.isNotEmpty);
    return lines.join('\n');
  }
}
