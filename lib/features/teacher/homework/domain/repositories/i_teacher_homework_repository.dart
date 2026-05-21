import 'package:elara/features/teacher/homework/domain/entities/teacher_homework_entity.dart';
import 'package:elara/features/teacher/homework/domain/entities/teacher_resource_entity.dart';

abstract interface class ITeacherHomeworkRepository {
  Future<TeacherHomeworkEntity> getModuleHomework({
    required String moduleId,
    required String groupId,
  });

  Future<List<TeacherResourceEntity>> getModuleResources({
    required String moduleId,
    required String groupId,
  });
}
