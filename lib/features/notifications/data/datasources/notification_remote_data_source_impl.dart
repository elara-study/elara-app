import 'package:dio/dio.dart';
import 'package:elara/core/constants/api_constants.dart';
import 'package:elara/features/notifications/data/datasources/notification_remote_data_source.dart';
import 'package:elara/features/notifications/data/models/notification_model.dart';
import 'package:elara/features/notifications/data/models/notification_preferences_model.dart';

/// Concrete implementation of [NotificationRemoteDataSource].
///
/// Uses the project's authenticated [Dio] instance (supplied via DI from
/// [DioClient]) so all requests automatically carry the Bearer token and go
/// through retry/session-expiry logic.
class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  final Dio _dio;

  NotificationRemoteDataSourceImpl(this._dio);

  // ── Device token ────────────────────────────────────────────────────────────

  @override
  Future<void> registerDeviceToken(String token) async {
    // POST /api/v1/notifications/device-token
    await _dio.post<dynamic>(
      ApiConstants.registerDeviceToken,
      data: {'token': token},
    );
  }

  @override
  Future<void> removeDeviceToken(String token) async {
    // DELETE /api/v1/notifications/device-token
    await _dio.delete<dynamic>(
      ApiConstants.removeDeviceToken,
      data: {'token': token},
    );
  }

  // ── Notification list ────────────────────────────────────────────────────────

  @override
  Future<List<NotificationModel>> getNotifications({
    required int page,
    required int limit,
  }) async {
    // GET /api/v1/notifications?page=&limit=
    final response = await _dio.get<dynamic>(
      ApiConstants.notifications,
      queryParameters: {'page': page, 'limit': limit},
    );

    final data = _extractData(response.data);
    if (data is! List) return [];
    return data
        .whereType<Map<String, dynamic>>()
        .map(NotificationModel.fromJson)
        .toList(growable: false);
  }

  @override
  Future<void> markAllNotificationsRead() async {
    // PATCH /api/v1/notifications
    await _dio.patch<dynamic>(ApiConstants.markAllNotificationsRead);
  }

  @override
  Future<int> getUnreadCount() async {
    // GET /api/v1/notifications/unread-count
    final response = await _dio.get<dynamic>(
      ApiConstants.notificationsUnreadCount,
    );
    final data = _extractData(response.data);
    // The spec says `data` is an integer.
    if (data is int) return data;
    if (data is num) return data.toInt();
    return 0;
  }

  @override
  Future<void> markNotificationRead(String id) async {
    // PATCH /api/v1/notifications/{id}
    await _dio.patch<dynamic>(ApiConstants.markNotificationRead(id));
  }

  @override
  Future<void> markMultipleNotificationsRead(List<String> ids) async {
    // PATCH /api/v1/notifications/batch
    await _dio.patch<dynamic>(
      ApiConstants.markMultipleNotificationsRead,
      data: {'notificationIds': ids},
    );
  }

  // ── Preferences ─────────────────────────────────────────────────────────────

  @override
  Future<NotificationPreferencesModel> getNotificationPreferences() async {
    // GET /api/v1/notifications/preferences
    final response = await _dio.get<dynamic>(
      ApiConstants.notificationPreferences,
    );
    final data = _extractData(response.data);
    if (data is Map<String, dynamic>) {
      return NotificationPreferencesModel.fromJson(data);
    }
    // Return safe defaults if the server returns an unexpected shape.
    return const NotificationPreferencesModel(
      groupUpdates: true,
      streakReminders: true,
      homeworkReminders: true,
      newLessons: true,
      aiProgressReports: true,
    );
  }

  @override
  Future<void> updateNotificationPreferences(
    NotificationPreferencesModel preferences,
  ) async {
    // PATCH /api/v1/notifications/preferences
    await _dio.patch<dynamic>(
      ApiConstants.updateNotificationPreferences,
      data: preferences.toJson(),
    );
  }

  // ── Helpers ──────────────────────────────────────────────────────────────────

  /// Unwraps the standard API envelope `{ "status", "message", "data": <T> }`
  /// and returns just the `data` field. Falls back to returning [body] as-is
  /// if the envelope is not present.
  dynamic _extractData(dynamic body) {
    if (body is Map<String, dynamic> && body.containsKey('data')) {
      return body['data'];
    }
    return body;
  }
}
