import 'package:elara/core/network/api_result.dart';
import 'package:elara/features/teacher/domain/homework/repositories/i_teacher_homework_repository.dart';

class DeleteTeacherProblemUseCase {
  final ITeacherHomeworkRepository _repository;

  const DeleteTeacherProblemUseCase(this._repository);

  Future<ApiResult<void>> call({required String problemId}) =>
      _repository.deleteProblem(problemId: problemId);
}
