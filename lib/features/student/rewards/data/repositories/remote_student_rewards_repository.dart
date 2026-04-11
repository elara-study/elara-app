import 'package:dio/dio.dart';
import 'package:elara/core/constants/api_constants.dart';
import 'package:elara/core/error/failures.dart';
import 'package:elara/core/network/api_result.dart';
import 'package:elara/core/network/dio_client.dart';
import 'package:elara/features/student/rewards/domain/entities/rewards_leaderboard_entry.dart';
import 'package:elara/features/student/rewards/domain/entities/student_rewards_overview.dart';
import 'package:elara/features/student/rewards/domain/repositories/student_rewards_repository.dart';

/// GET /v1/student/rewards/overview and …/leaderboard per OpenAPI.
class RemoteStudentRewardsRepository implements StudentRewardsRepository {
  final DioClient _dioClient;

  RemoteStudentRewardsRepository(this._dioClient);

  @override
  Future<ApiResult<StudentRewardsOverview>> getOverview() async {
    try {
      final response = await _dioClient.dio.get<dynamic>(
        ApiConstants.studentRewardsOverview,
      );
      final map = _asJsonMap(_unwrap(response.data));
      if (map == null) {
        return ApiResult.failure(
          const ServerFailure('Invalid rewards overview response'),
        );
      }
      return ApiResult.success(StudentRewardsOverview.fromJson(map));
    } on DioException catch (e) {
      return ApiResult.failure(_mapDio(e));
    } catch (_) {
      return ApiResult.failure(
        const UnknownFailure('Failed to parse rewards overview'),
      );
    }
  }

  @override
  Future<ApiResult<List<RewardsLeaderboardEntry>>> getLeaderboard() async {
    try {
      final response = await _dioClient.dio.get<dynamic>(
        ApiConstants.studentRewardsLeaderboard,
      );
      final root = _asJsonMap(_unwrap(response.data));
      if (root == null) {
        return ApiResult.failure(
          const ServerFailure('Invalid rewards leaderboard response'),
        );
      }
      final raw = root['leaderboard'];
      if (raw is! List) {
        return ApiResult.failure(
          const ServerFailure('Missing leaderboard array'),
        );
      }
      final entries = raw
          .whereType<Map<String, dynamic>>()
          .map(RewardsLeaderboardEntry.fromJson)
          .toList(growable: false);
      return ApiResult.success(entries);
    } on DioException catch (e) {
      return ApiResult.failure(_mapDio(e));
    } catch (_) {
      return ApiResult.failure(
        const UnknownFailure('Failed to parse rewards leaderboard'),
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

dynamic _unwrap(dynamic body) {
  if (body is Map<String, dynamic>) {
    final data = body['data'];
    if (data != null) return data;
  }
  return body;
}

Map<String, dynamic>? _asJsonMap(dynamic v) {
  if (v is Map<String, dynamic>) return v;
  return null;
}
