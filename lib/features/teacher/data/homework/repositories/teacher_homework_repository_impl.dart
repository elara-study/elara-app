import 'package:dio/dio.dart';
import 'package:elara/core/error/failures.dart';
import 'package:elara/core/network/api_result.dart';
import 'package:elara/features/teacher/data/homework/datasources/teacher_homework_datasource.dart';
import 'package:elara/features/teacher/domain/homework/entities/teacher_homework_entity.dart';
import 'package:elara/features/teacher/domain/homework/entities/teacher_homework_problem_entity.dart';
import 'package:elara/features/teacher/domain/homework/entities/teacher_resource_entity.dart';
import 'package:elara/features/teacher/domain/homework/repositories/i_teacher_homework_repository.dart';

class TeacherHomeworkRepositoryImpl implements ITeacherHomeworkRepository {
  final TeacherHomeworkDatasource _datasource;

  const TeacherHomeworkRepositoryImpl(this._datasource);

  @override
  Future<ApiResult<TeacherHomeworkEntity>> getModuleHomework({
    required String moduleId,
    required String groupId,
  }) async {
    try {
      final homework = await _datasource.getModuleHomework(
        moduleId: moduleId,
        groupId: groupId,
      );
      return ApiResult.success(homework);
    } on DioException catch (e) {
      return ApiResult.failure(_mapDioToFailure(e));
    } catch (_) {
      return ApiResult.failure(
        const UnknownFailure('Failed to load module homework'),
      );
    }
  }

  @override
  Future<ApiResult<TeacherHomeworkProblemEntity>> addModuleProblem({
    required String moduleId,
    required String description,
  }) async {
    try {
      final problem = await _datasource.addModuleProblem(
        moduleId: moduleId,
        description: description,
      );
      return ApiResult.success(problem);
    } on DioException catch (e) {
      return ApiResult.failure(_mapDioToFailure(e));
    } catch (_) {
      return ApiResult.failure(
        const UnknownFailure('Failed to add homework problem'),
      );
    }
  }

  @override
  Future<ApiResult<TeacherHomeworkProblemEntity>> updateProblem({
    required String problemId,
    required String description,
  }) async {
    try {
      final problem = await _datasource.updateProblem(
        problemId: problemId,
        description: description,
      );
      return ApiResult.success(problem);
    } on DioException catch (e) {
      return ApiResult.failure(_mapDioToFailure(e));
    } catch (_) {
      return ApiResult.failure(
        const UnknownFailure('Failed to update homework problem'),
      );
    }
  }

  @override
  Future<ApiResult<void>> deleteProblem({required String problemId}) async {
    try {
      await _datasource.deleteProblem(problemId: problemId);
      return ApiResult.success(null);
    } on DioException catch (e) {
      return ApiResult.failure(_mapDioToFailure(e));
    } catch (_) {
      return ApiResult.failure(
        const UnknownFailure('Failed to delete homework problem'),
      );
    }
  }

  @override
  Future<ApiResult<List<TeacherResourceEntity>>> getModuleResources({
    required String moduleId,
    required String groupId,
  }) async {
    try {
      final resources = await _datasource.getModuleResources(
        moduleId: moduleId,
        groupId: groupId,
      );
      return ApiResult.success(resources);
    } on DioException catch (e) {
      return ApiResult.failure(_mapDioToFailure(e));
    } catch (_) {
      return ApiResult.failure(
        const UnknownFailure('Failed to load module resources'),
      );
    }
  }

  @override
  Future<ApiResult<TeacherResourceEntity>> addModuleResource({
    required String moduleId,
    required String title,
    required String filePath,
  }) async {
    try {
      final resource = await _datasource.addModuleResource(
        moduleId: moduleId,
        title: title,
        filePath: filePath,
      );
      return ApiResult.success(resource);
    } on DioException catch (e) {
      return ApiResult.failure(_mapDioToFailure(e));
    } catch (_) {
      return ApiResult.failure(
        const UnknownFailure('Failed to add module resource'),
      );
    }
  }

  Failure _mapDioToFailure(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.connectionError) {
      return NetworkFailure(e.message ?? 'Network error');
    }

    final statusCode = e.response?.statusCode;
    final message = e.response?.data is Map<String, dynamic>
        ? (e.response?.data as Map<String, dynamic>)['message']?.toString()
        : null;

    return ServerFailure(
      message ??
          (statusCode != null
              ? 'HTTP $statusCode'
              : e.message ?? 'Server error'),
    );
  }
}
