import 'package:elara/features/teacher/homework/data/datasources/teacher_homework_datasource.dart';
import 'package:elara/features/teacher/homework/domain/entities/teacher_homework_entity.dart';
import 'package:elara/features/teacher/homework/domain/entities/teacher_resource_entity.dart';
import 'package:elara/features/teacher/homework/domain/repositories/i_teacher_homework_repository.dart';

class TeacherHomeworkRepositoryImpl implements ITeacherHomeworkRepository {
  final TeacherHomeworkDatasource _datasource;

  const TeacherHomeworkRepositoryImpl(this._datasource);

  @override
  Future<TeacherHomeworkEntity> getModuleHomework({
    required String moduleId,
    required String groupId,
  }) => _datasource.getModuleHomework(moduleId: moduleId, groupId: groupId);

  @override
  Future<List<TeacherResourceEntity>> getModuleResources({
    required String moduleId,
    required String groupId,
  }) => _datasource.getModuleResources(moduleId: moduleId, groupId: groupId);
}
