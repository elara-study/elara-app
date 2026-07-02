import 'package:elara/core/network/api_result.dart';
import 'package:elara/features/student/domain/quiz/entities/quiz_hint.dart';
import 'package:elara/features/student/domain/quiz/repositories/quiz_repository.dart';

/// Fetches a hint for a specific question in an active quiz session.
class GetHintUseCase {
  GetHintUseCase(this._repository);

  final QuizRepository _repository;

  Future<ApiResult<QuizHint>> call({
    required int sessionId,
    required int questionNumber,
  }) =>
      _repository.getHint(sessionId: sessionId, questionNumber: questionNumber);
}
