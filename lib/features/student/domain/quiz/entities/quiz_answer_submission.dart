import 'package:equatable/equatable.dart';

/// One answer sent with [QuizRepository.submitAnswers].
class QuizAnswerSubmission extends Equatable {
  const QuizAnswerSubmission({
    required this.questionId,
    this.selectedOptionId,
    this.writtenText,
  });

  final String questionId;
  final String? selectedOptionId;
  final String? writtenText;

  @override
  List<Object?> get props => [questionId, selectedOptionId, writtenText];
}
