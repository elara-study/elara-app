import 'package:elara/features/student/domain/quiz/entities/quiz_hint.dart';

/// JSON model for the hint response from GET /api/v1/quiz/sessions/:id/questions/:n/hint.
class QuizHintModel {
  const QuizHintModel({required this.content, required this.hintLevel});

  final String content;
  final int hintLevel;

  factory QuizHintModel.fromJson(Map<String, dynamic> json) {
    return QuizHintModel(
      content: json['content'] as String,
      hintLevel: json['hintLevel'] as int,
    );
  }

  QuizHint toEntity() => QuizHint(content: content, hintLevel: hintLevel);
}
