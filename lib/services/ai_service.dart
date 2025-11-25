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

class QuizQuestion {
  const QuizQuestion({
    required this.prompt,
    required this.options,
    this.answer,
  });

  final String prompt;
  final List<String> options;
  final String? answer;

  int? get correctOptionIndex {
    if (answer == null) {
      return null;
    }
    final int index = options
        .indexWhere((String option) => option.toLowerCase() == answer!.toLowerCase());
    return index == -1 ? null : index;
  }

  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    List<String> toOptions(dynamic value) {
      if (value is List) {
        return value
            .whereType<String>()
            .map((String item) => item.trim())
            .where((String item) => item.isNotEmpty)
            .toList();
      }
      return <String>[];
    }

    final String? answer = (json['answer'] as String?)?.trim();
    return QuizQuestion(
      prompt: (json['prompt'] as String?)?.trim() ?? '',
      options: toOptions(json['options']),
      answer: answer?.isEmpty ?? true ? null : answer,
    );
  }
}

class QuizResultsSummary {
  const QuizResultsSummary({
    required this.quote,
    required this.author,
    required this.feedback,
  });

  final String quote;
  final String author;
  final String feedback;

  factory QuizResultsSummary.fromJson(Map<String, dynamic> json) {
    String clean(dynamic value, {String fallback = ''}) {
      if (value is String) {
        return value.trim();
      }
      return fallback;
    }

    return QuizResultsSummary(
      quote: clean(json['quote'], fallback: 'Keep learning and growing.'),
      author: clean(json['author'], fallback: 'Unknown'),
      feedback: clean(
        json['feedback'],
        fallback: 'Wonderful effort—stay curious!',
      ),
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

  Future<List<QuizQuestion>> generateQuiz(
    String content, {
    int maxQuestions = 10,
  }) async {
    final String trimmed = _normalizeContent(content);
    if (trimmed.isEmpty) {
      throw StateError('There is no study text to analyze.');
    }

    final int limit = maxQuestions.clamp(1, 10);

    final String prompt = '''
You are Sylo, an encouraging academic coach.
Create as many distinct multiple-choice quiz questions as the material allows, up to $limit questions. Prefer generating $limit questions when possible.
Respond with JSON that matches this schema exactly:
{
  "questions": [
    {
      "prompt": string,
      "options": [string, ...],
      "answer": string
    }, ...
  ]
}
Rules:
- Provide 4 answer options whenever the content supports it; never provide fewer than 3.
- "answer" must exactly match one of the options.
- Do not add numbering or extra narration.
- Base every question solely on the supplied content.
- Ensure each question covers a different fact or concept to avoid repetition.

CONTENT:
$trimmed
''';

    final GenerateContentResponse response;
    try {
      response =
          await _model.generateContent(<Content>[Content.text(prompt)]);
    } on GenerativeAIException catch (error) {
      final String details = error.message.trim();
      final String message =
          details.isNotEmpty ? details : 'Gemini rejected the request.';
      throw StateError(message);
    } catch (error) {
      throw StateError('Gemini request failed: $error');
    }

    final String raw = response.text?.trim() ?? '';
    if (raw.isEmpty) {
      throw StateError('Gemini did not return any quiz questions.');
    }

    final String jsonPayload = _extractJson(raw);

    try {
      final dynamic decoded = jsonDecode(jsonPayload);
      if (decoded is! Map<String, dynamic>) {
        throw const FormatException('Response root is not a JSON object.');
      }

      final List<dynamic>? questionList = decoded['questions'] as List<dynamic>?;
      if (questionList == null) {
        throw const FormatException('Missing "questions" array.');
      }

      final List<QuizQuestion> questions = questionList
          .whereType<Map<String, dynamic>>()
          .map(QuizQuestion.fromJson)
          .where((QuizQuestion question) =>
            question.prompt.isNotEmpty &&
            question.options.length >= 3 &&
            question.correctOptionIndex != null)
          .take(limit)
          .toList();

      if (questions.isEmpty) {
        throw const FormatException('No valid quiz questions were generated.');
      }

      return questions;
    } on FormatException catch (error) {
      throw StateError('Unable to parse quiz. ${error.message}');
    }
  }

  Future<QuizResultsSummary> buildQuizSummary({
    required String content,
    required int total,
    required int correct,
  }) async {
    final String trimmed = _normalizeContent(content);
    if (trimmed.isEmpty) {
      throw StateError('There is no study text to analyze.');
    }

    final int safeTotal = total.clamp(0, 1000);
    final int safeCorrect = correct.clamp(0, safeTotal);

    final String prompt = '''
You are Sylo, an encouraging academic coach.
Based on the learner's quiz result ($safeCorrect out of $safeTotal correct) and the provided study material, craft a short motivational response.
Return JSON matching this schema exactly:
{
  "quote": string,
  "author": string,
  "feedback": string
}
Rules:
- The quote should be relevant to the subject matter of the provided content.
- The author field must be the real or commonly attributed source (or "Unknown" if not sure).
- The feedback should acknowledge the score and offer a next-step suggestion in 1-2 sentences.
- Do not include markdown or quotation marks around values.

CONTENT:
$trimmed
''';

    final GenerateContentResponse response;
    try {
      response =
          await _model.generateContent(<Content>[Content.text(prompt)]);
    } on GenerativeAIException catch (error) {
      final String details = error.message.trim();
      final String message =
          details.isNotEmpty ? details : 'Gemini rejected the request.';
      throw StateError(message);
    } catch (error) {
      throw StateError('Gemini request failed: $error');
    }

    final String raw = response.text?.trim() ?? '';
    if (raw.isEmpty) {
      throw StateError('Gemini did not return a quiz summary.');
    }

    final String jsonPayload = _extractJson(raw);

    try {
      final Map<String, dynamic> data =
          jsonDecode(jsonPayload) as Map<String, dynamic>;
      return QuizResultsSummary.fromJson(data);
    } on FormatException catch (error) {
      throw StateError('Unable to parse quiz summary. ${error.message}');
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
