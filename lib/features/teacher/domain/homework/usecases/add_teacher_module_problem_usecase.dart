import 'package:elara/core/network/api_result.dart';
import 'package:elara/features/teacher/domain/homework/entities/teacher_homework_problem_entity.dart';
import 'package:elara/features/teacher/domain/homework/repositories/i_teacher_homework_repository.dart';

class AddTeacherModuleProblemUseCase {
  final ITeacherHomeworkRepository _repository;

  const AddTeacherModuleProblemUseCase(this._repository);

  Future<ApiResult<TeacherHomeworkProblemEntity>> call({
    required String moduleId,
    required String description,
  }) => _repository.addModuleProblem(
    moduleId: moduleId,
    description: description,
  );
}
