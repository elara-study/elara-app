import 'package:elara/core/network/api_result.dart';
import 'package:elara/features/student/domain/quiz/entities/answer_result.dart';
import 'package:elara/features/student/domain/quiz/repositories/quiz_repository.dart';

/// Submits a single answer for the current question and returns per-question feedback.
class SubmitAnswerUseCase {
  SubmitAnswerUseCase(this._repository);

  final QuizRepository _repository;

  Future<ApiResult<AnswerResult>> call({
    required int sessionId,
    required int questionNumber,
    required String questionType,
    String? selectedOptionText,
    String? answerContent,
    required bool hintUsed,
  }) =>
      _repository.submitAnswer(
        sessionId: sessionId,
        questionNumber: questionNumber,
        questionType: questionType,
        selectedOptionText: selectedOptionText,
        answerContent: answerContent,
        hintUsed: hintUsed,
      );
}
