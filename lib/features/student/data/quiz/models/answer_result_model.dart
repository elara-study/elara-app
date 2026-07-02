import 'package:elara/features/student/domain/quiz/entities/answer_result.dart';

/// JSON model for the per-question answer result from POST /api/v1/quiz/sessions/:id/answers.
class AnswerResultModel {
  const AnswerResultModel({
    required this.questionNumber,
    required this.isCorrect,
    required this.correctAnswerText,
    required this.xpAwarded,
  });

  final int questionNumber;
  final bool isCorrect;
  final String correctAnswerText;
  final int xpAwarded;

  factory AnswerResultModel.fromJson(Map<String, dynamic> json) {
    return AnswerResultModel(
      questionNumber: (json['questionNumber'] as num? ?? 0).toInt(),
      isCorrect: json['isCorrect'] as bool? ?? false,
      correctAnswerText: json['correctAnswerText'] as String? ?? '',
      xpAwarded: (json['xpAwarded'] as num? ?? 0).toInt(),
    );
  }

  AnswerResult toEntity() {
    return AnswerResult(
      questionNumber: questionNumber,
      isCorrect: isCorrect,
      correctAnswerText: correctAnswerText,
      xpAwarded: xpAwarded,
    );
  }
}
