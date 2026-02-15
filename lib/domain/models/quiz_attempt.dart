import 'package:equatable/equatable.dart';

class QuizAttempt extends Equatable {
  const QuizAttempt({
    required this.id,
    required this.quizId,
    required this.studentId,
    required this.answers,
    this.score,
    this.feedback,
  });

  final String id;
  final String quizId;
  final String studentId;
  final Map<String, String> answers;
  final double? score;
  final String? feedback;

  @override
  List<Object?> get props => [id, quizId, studentId, answers, score, feedback];
}
