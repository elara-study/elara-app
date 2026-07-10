import 'package:equatable/equatable.dart';

/// Per-question answer feedback returned immediately after [submitAnswer].
class AnswerResult extends Equatable {
  const AnswerResult({
    required this.questionNumber,
    required this.isCorrect,
    required this.correctAnswerText,
    required this.xpAwarded,
  });

  final int questionNumber;
  final bool isCorrect;
  final String correctAnswerText;
  final int xpAwarded;

  @override
  List<Object?> get props => [
    questionNumber,
    isCorrect,
    correctAnswerText,
    xpAwarded,
  ];
}
