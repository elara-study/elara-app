import 'package:elara/features/teacher/homework/domain/entities/teacher_resource_entity.dart';
import 'package:elara/features/teacher/homework/domain/repositories/i_teacher_homework_repository.dart';

class GetTeacherModuleResourcesUseCase {
  final ITeacherHomeworkRepository _repository;

  const GetTeacherModuleResourcesUseCase(this._repository);

  Future<List<TeacherResourceEntity>> call({
    required String moduleId,
    required String groupId,
  }) => _repository.getModuleResources(moduleId: moduleId, groupId: groupId);
}
