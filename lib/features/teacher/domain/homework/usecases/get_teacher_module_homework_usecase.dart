import 'package:elara/core/network/api_result.dart';
import 'package:elara/features/teacher/domain/homework/entities/teacher_homework_entity.dart';
import 'package:elara/features/teacher/domain/homework/repositories/i_teacher_homework_repository.dart';

class GetTeacherModuleHomeworkUseCase {
  final ITeacherHomeworkRepository _repository;

  const GetTeacherModuleHomeworkUseCase(this._repository);

  Future<ApiResult<TeacherHomeworkEntity>> call({
    required String moduleId,
    required String groupId,
  }) => _repository.getModuleHomework(moduleId: moduleId, groupId: groupId);
}
