import 'package:elara/core/network/api_result.dart';
import 'package:elara/features/student/domain/quiz/entities/quiz_session.dart';
import 'package:elara/features/student/domain/quiz/repositories/quiz_repository.dart';

/// Generates a new quiz session from the backend.
class GenerateQuizUseCase {
  GenerateQuizUseCase(this._repository);

  final QuizRepository _repository;

  Future<ApiResult<QuizSession>> call({
    required String groupId,
    required String moduleId,
    required int questionCount,
    required String difficultyLevel,
    required List<String> questionTypes,
  }) =>
      _repository.generateQuiz(
        groupId: groupId,
        moduleId: moduleId,
        questionCount: questionCount,
        difficultyLevel: difficultyLevel,
        questionTypes: questionTypes,
      );
}
