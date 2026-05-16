import 'package:elara/core/network/api_result.dart';
import 'package:elara/features/student/domain/quiz/entities/quiz_session.dart';
import 'package:elara/features/student/domain/quiz/repositories/quiz_repository.dart';

class GetQuizSessionUseCase {
  GetQuizSessionUseCase(this._repository);

  final QuizRepository _repository;

  Future<ApiResult<QuizSession>> call({
    required String quizId,
    String? groupId,
    String? moduleId,
  }) => _repository.getSession(
    quizId: quizId,
    groupId: groupId,
    moduleId: moduleId,
  );
}
