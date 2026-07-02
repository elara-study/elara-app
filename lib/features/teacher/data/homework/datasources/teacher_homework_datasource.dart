import 'package:elara/features/teacher/data/homework/models/teacher_homework_model.dart';
import 'package:elara/features/teacher/data/homework/models/teacher_homework_problem_model.dart';
import 'package:elara/features/teacher/data/homework/models/teacher_resource_model.dart';

abstract interface class TeacherHomeworkDatasource {
  Future<TeacherHomeworkModel> getModuleHomework({
    required String moduleId,
    required String groupId,
  });

  Future<List<TeacherResourceModel>> getModuleResources({
    required String moduleId,
    required String groupId,
  });

  Future<TeacherHomeworkProblemModel> addModuleProblem({
    required String moduleId,
    required String description,
  });

  Future<TeacherHomeworkProblemModel> updateProblem({
    required String problemId,
    required String description,
  });

  Future<void> deleteProblem({required String problemId});
}
