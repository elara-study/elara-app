import 'package:dio/dio.dart';
import 'package:elara/core/error/failures.dart';
import 'package:elara/core/network/api_result.dart';
import 'package:elara/features/notifications/data/datasources/notification_remote_data_source.dart';
import 'package:elara/features/notifications/data/models/notification_preferences_model.dart';
import 'package:elara/features/notifications/domain/entities/notification_entity.dart';
import 'package:elara/features/notifications/domain/entities/notification_preferences_entity.dart';
import 'package:elara/features/notifications/domain/repositories/notification_repository.dart';

/// Concrete implementation of [NotificationRepository].
///
/// Delegates all network I/O to [NotificationRemoteDataSource] and wraps
/// every call in try/catch so that [DioException] and unexpected errors
/// never escape to the domain or presentation layers.
class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDataSource _dataSource;

  const NotificationRepositoryImpl(this._dataSource);

  // ── Device token ────────────────────────────────────────────────────────────

  @override
  Future<ApiResult<void>> registerDeviceToken(String token) async {
    return _run(() => _dataSource.registerDeviceToken(token));
  }

  @override
  Future<ApiResult<void>> removeDeviceToken(String token) async {
    return _run(() => _dataSource.removeDeviceToken(token));
  }

  // ── Notification list ────────────────────────────────────────────────────────

  @override
  Future<ApiResult<List<NotificationEntity>>> getNotifications({
    required int page,
    required int limit,
  }) async {
    return _run(
      () => _dataSource.getNotifications(page: page, limit: limit),
    );
  }

  @override
  Future<ApiResult<void>> markAllNotificationsRead() async {
    return _run(() => _dataSource.markAllNotificationsRead());
  }

  @override
  Future<ApiResult<int>> getUnreadCount() async {
    return _run(() => _dataSource.getUnreadCount());
  }

  @override
  Future<ApiResult<void>> markNotificationRead(String id) async {
    return _run(() => _dataSource.markNotificationRead(id));
  }

  @override
  Future<ApiResult<void>> markMultipleNotificationsRead(
    List<String> ids,
  ) async {
    return _run(() => _dataSource.markMultipleNotificationsRead(ids));
  }

  // ── Preferences ─────────────────────────────────────────────────────────────

  @override
  Future<ApiResult<NotificationPreferencesEntity>>
  getNotificationPreferences() async {
    return _run(() => _dataSource.getNotificationPreferences());
  }

  @override
  Future<ApiResult<void>> updateNotificationPreferences(
    NotificationPreferencesEntity preferences,
  ) async {
    // Map entity → model so the data source gets a type with toJson().
    final model = NotificationPreferencesModel(
      groupUpdates: preferences.groupUpdates,
      streakReminders: preferences.streakReminders,
      homeworkReminders: preferences.homeworkReminders,
      newLessons: preferences.newLessons,
      aiProgressReports: preferences.aiProgressReports,
    );
    return _run(() => _dataSource.updateNotificationPreferences(model));
  }

  // ── Error mapping ────────────────────────────────────────────────────────────

  /// Executes [action] and wraps any exception in [ApiResult.failure].
  Future<ApiResult<T>> _run<T>(Future<T> Function() action) async {
    try {
      final result = await action();
      return ApiResult.success(result as T);
    } on DioException catch (e) {
      return ApiResult.failure(_mapDio(e));
    } catch (e) {
      return ApiResult.failure(
        UnknownFailure(e.toString()),
      );
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
}
