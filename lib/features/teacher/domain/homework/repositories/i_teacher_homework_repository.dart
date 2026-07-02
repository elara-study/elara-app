import 'package:elara/core/network/api_result.dart';
import 'package:elara/features/teacher/domain/homework/entities/teacher_homework_entity.dart';
import 'package:elara/features/teacher/domain/homework/entities/teacher_homework_problem_entity.dart';
import 'package:elara/features/teacher/domain/homework/entities/teacher_resource_entity.dart';

abstract interface class ITeacherHomeworkRepository {
  Future<ApiResult<TeacherHomeworkEntity>> getModuleHomework({
    required String moduleId,
    required String groupId,
  });

  Future<ApiResult<List<TeacherResourceEntity>>> getModuleResources({
    required String moduleId,
    required String groupId,
  });

  Future<ApiResult<TeacherHomeworkProblemEntity>> addModuleProblem({
    required String moduleId,
    required String description,
  });

  Future<ApiResult<TeacherHomeworkProblemEntity>> updateProblem({
    required String problemId,
    required String description,
  });

  Future<ApiResult<void>> deleteProblem({required String problemId});
}
