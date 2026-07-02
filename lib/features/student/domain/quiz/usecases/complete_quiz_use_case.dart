import 'package:elara/core/network/api_result.dart';
import 'package:elara/features/student/domain/quiz/entities/quiz_results.dart';
import 'package:elara/features/student/domain/quiz/repositories/quiz_repository.dart';

/// Marks a quiz session as complete and retrieves the final results.
class CompleteQuizUseCase {
  CompleteQuizUseCase(this._repository);

  final QuizRepository _repository;

  Future<ApiResult<QuizResults>> call(int sessionId) =>
      _repository.completeQuiz(sessionId);
}
