// lib/services/ai_service.dart

import 'dart:convert';

import 'package:google_generative_ai/google_generative_ai.dart';

import '../config/env.dart';

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
    List<String> stringList(dynamic value) {
      if (value is List) {
        return value.whereType<String>().map((String item) => item.trim()).toList();
      }
      return <String>[];
    }

    return StudySummary(
      title: (json['title'] as String?)?.trim() ?? 'Study Brief',
      overview: (json['overview'] as String?)?.trim() ?? '',
      keyPoints: stringList(json['keyPoints']),
      studyTips: stringList(json['studyTips']),
      followUp: stringList(json['followUp']),
    );
  }
}

class AIService {
  AIService({String? apiKey})
      : _apiKey = apiKey ?? Env.geminiKey,
        _moderationModel = GenerativeModel(
          model: 'gemini-2.0-flash',
          apiKey: apiKey ?? Env.geminiKey,
        ),
        _summaryModel = GenerativeModel(
          model: 'gemini-2.0-flash',
          apiKey: apiKey ?? Env.geminiKey,
          generationConfig: GenerationConfig(
            responseMimeType: 'application/json',
            temperature: 0.2,
          ),
        ) {
    if (_apiKey.isEmpty) {
      throw StateError(
        'Gemini API key missing. Run the app with --dart-define=GEMINI_KEY=your_key.',
      );
    }
  }

  final String _apiKey;
  final GenerativeModel _moderationModel;
  final GenerativeModel _summaryModel;

  /// Determine if the provided content is academic.
  Future<bool> isAcademicContent(String content) async {
    final String prompt = '''
You are a moderation assistant for an academic learning platform.
Review the learner-provided content and decide if it is academically relevant.

Output must be a single token, either:
ACADEMIC – if the content is educational, scholarly, or study related.
NOT_ACADEMIC – for anything off-topic, harmful, explicit, or non-educational.

CONTENT:
$content
''';

    final GenerateContentResponse response =
      await _moderationModel.generateContent(<Content>[Content.text(prompt)]);
    final String result = response.text?.trim().toUpperCase() ?? '';

    return result.contains('ACADEMIC');
  }

  /// Generate structured study insights used by the "analyze" action.
  Future<StudySummary> generateInsights(String content) async {
    final bool isAcademic = await isAcademicContent(content);
    if (!isAcademic) {
      throw StateError(
        '❌ This content cannot be used. Please upload academic materials only.',
      );
    }

    final String normalized = _normalizeWhitespace(content);

    final String prompt = '''
You are Sylo, a friendly academic study coach helping high school and college learners.

Task: produce a concise study brief for the provided material. Keep the tone encouraging and informative.

Respond ONLY with valid JSON that matches this schema:
{
  "title": string,
  "overview": string,
  "keyPoints": [string, ...],
  "studyTips": [string, ...],
  "followUp": [string, ...]
}

Rules:
- Do not include any introductory or trailing text outside of the JSON.
- Use simple, learner-friendly language.
- If content includes equations or code, keep original notation.
- Never hallucinate: rely only on the provided content.

CONTENT:
$normalized
''';

    final GenerateContentResponse response =
      await _summaryModel.generateContent(<Content>[Content.text(prompt)]);
    final String raw = response.text?.trim() ?? '';
    if (raw.isEmpty) {
      throw StateError('No response from AI service.');
    }

    final String jsonPayload = _extractJson(raw);

    try {
      final Map<String, dynamic> data =
          jsonDecode(jsonPayload) as Map<String, dynamic>;
      return StudySummary.fromJson(data);
    } on FormatException catch (error) {
      throw StateError('Unable to parse study brief. $error');
    }
  }

  /// Generate practice quizzes used by the "try quiz" action.
  Future<String> generateQuizzes(String content, int count) async {
    final bool isAcademic = await isAcademicContent(content);
    if (!isAcademic) {
      return '❌ Cannot generate quizzes. Content is not academic.';
    }

    final String prompt = '''
You are Sylo, an academic quiz coach. Create $count multiple-choice questions for a learner.

Output format (repeat for each question):
Q#: Question text
A) option
B) option
C) option
D) option
Correct Answer: letter
Why it matters: 1 sentence explaining the correct answer.

Instructions:
- Target difficulty should match undergraduate introductory courses.
- Pull facts strictly from the provided content—no outside knowledge.
- Mix conceptual and applied questions when possible.
- Ensure distractors (wrong answers) are plausible but clearly incorrect.

CONTENT:
$content
''';

    final GenerateContentResponse response =
      await _moderationModel.generateContent(<Content>[Content.text(prompt)]);
    return response.text ?? 'No response';
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

  String _normalizeWhitespace(String input) {
    final String withoutTabs = input.replaceAll(RegExp(r'[\t]+'), ' ');
    final Iterable<String> lines = withoutTabs
        .split(RegExp(r'\r?\n'))
        .map((String line) => line.trim())
        .where((String line) => line.isNotEmpty);
    return lines.join('\n');
  }
}
