import 'package:elara/features/teacher/homework/data/models/teacher_homework_model.dart';
import 'package:elara/features/teacher/homework/data/models/teacher_resource_model.dart';

abstract interface class TeacherHomeworkDatasource {
  Future<TeacherHomeworkModel> getModuleHomework({
    required String moduleId,
    required String groupId,
  });

  Future<List<TeacherResourceModel>> getModuleResources({
    required String moduleId,
    required String groupId,
  });
}
