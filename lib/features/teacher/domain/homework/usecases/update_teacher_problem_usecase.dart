import 'package:elara/core/network/api_result.dart';
import 'package:elara/features/teacher/domain/homework/entities/teacher_homework_problem_entity.dart';
import 'package:elara/features/teacher/domain/homework/repositories/i_teacher_homework_repository.dart';

class UpdateTeacherProblemUseCase {
  final ITeacherHomeworkRepository _repository;

  const UpdateTeacherProblemUseCase(this._repository);

  Future<ApiResult<TeacherHomeworkProblemEntity>> call({
    required String problemId,
    required String description,
  }) =>
      _repository.updateProblem(problemId: problemId, description: description);
}
