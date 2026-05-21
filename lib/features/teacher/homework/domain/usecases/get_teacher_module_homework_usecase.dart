import 'package:elara/features/teacher/homework/domain/entities/teacher_homework_entity.dart';
import 'package:elara/features/teacher/homework/domain/repositories/i_teacher_homework_repository.dart';

class GetTeacherModuleHomeworkUseCase {
  final ITeacherHomeworkRepository _repository;

  const GetTeacherModuleHomeworkUseCase(this._repository);

  Future<TeacherHomeworkEntity> call({
    required String moduleId,
    required String groupId,
  }) => _repository.getModuleHomework(moduleId: moduleId, groupId: groupId);
}
