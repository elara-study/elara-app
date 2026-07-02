import 'package:dio/dio.dart';
import 'package:elara/core/error/exceptions.dart';
import 'package:elara/core/error/failures.dart';
import 'package:elara/core/network/api_result.dart';
import 'package:elara/features/student/learn/data/datasources/learn_remote_datasource.dart';
import 'package:elara/features/student/learn/domain/entities/student_group.dart';
import 'package:elara/features/student/learn/domain/repositories/learn_repository.dart';

class LearnRepositoryImpl implements LearnRepository {
  final LearnRemoteDataSource _remoteDataSource;

  LearnRepositoryImpl({required LearnRemoteDataSource remoteDataSource})
    : _remoteDataSource = remoteDataSource;

  @override
  Future<ApiResult<List<StudentGroup>>> getGroups() async {
    try {
      final models = await _remoteDataSource.getGroups();
      final groups = models.map((m) => m.toEntity()).toList(growable: false);
      return ApiResult.success(groups);
    } on ServerException catch (e) {
      return ApiResult.failure(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return ApiResult.failure(NetworkFailure(e.message));
    } on DioException catch (e) {
      return ApiResult.failure(_mapDio(e));
    } catch (_) {
      return ApiResult.failure(
        const UnknownFailure('Failed to load student groups'),
      );
    }
  }
}

Failure _mapDio(DioException e) {
  if (e.type == DioExceptionType.connectionTimeout ||
      e.type == DioExceptionType.receiveTimeout ||
      e.type == DioExceptionType.connectionError) {
    return NetworkFailure(e.message ?? 'Network error');
  }
  final status = e.response?.statusCode;
  final msg = e.response?.data is Map<String, dynamic>
      ? (e.response!.data as Map<String, dynamic>)['message']?.toString()
      : null;
  return ServerFailure(
    msg ?? (status != null ? 'HTTP $status' : e.message ?? 'Server error'),
  );
}
