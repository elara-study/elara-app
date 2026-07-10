import 'package:elara/core/network/api_result.dart';
import 'package:elara/features/student/domain/quiz/entities/quiz_answer_submission.dart';
import 'package:elara/features/student/domain/quiz/entities/quiz_results.dart';
import 'package:elara/features/student/domain/quiz/repositories/quiz_repository.dart';

class SubmitQuizAnswersUseCase {
  SubmitQuizAnswersUseCase(this._repository);

  final QuizRepository _repository;

  Future<ApiResult<QuizResults>> call({
    required String quizId,
    required List<QuizAnswerSubmission> answers,
  }) => _repository.submitAnswers(quizId: quizId, answers: answers);
}
