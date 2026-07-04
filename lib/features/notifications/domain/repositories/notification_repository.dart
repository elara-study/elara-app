import 'package:elara/core/network/api_result.dart';
import 'package:elara/features/notifications/domain/entities/notification_entity.dart';
import 'package:elara/features/notifications/domain/entities/notification_preferences_entity.dart';

/// Domain-layer contract for all notification operations.
///
/// Uses [ApiResult] for consistent error handling across the call-site
/// (matching the pattern already used in rewards and quiz repositories).
abstract class NotificationRepository {
  // ── Device token ────────────────────────────────────────────────────────────

  /// Registers the FCM [token] with the backend.
  Future<ApiResult<void>> registerDeviceToken(String token);

  /// Removes the FCM [token] from the backend (e.g. on sign-out).
  Future<ApiResult<void>> removeDeviceToken(String token);

  // ── Notification list ────────────────────────────────────────────────────────

  /// Returns a paginated list of notifications.
  Future<ApiResult<List<NotificationEntity>>> getNotifications({
    required int page,
    required int limit,
  });

  /// Marks all notifications as read server-side.
  Future<ApiResult<void>> markAllNotificationsRead();

  /// Returns the number of unread notifications.
  Future<ApiResult<int>> getUnreadCount();

  /// Marks a single notification identified by [id] as read.
  Future<ApiResult<void>> markNotificationRead(String id);

  /// Marks multiple notifications identified by [ids] as read.
  Future<ApiResult<void>> markMultipleNotificationsRead(List<String> ids);

  // ── Preferences ─────────────────────────────────────────────────────────────

  /// Returns the user's current notification preferences.
  Future<ApiResult<NotificationPreferencesEntity>> getNotificationPreferences();

  /// Persists updated notification [preferences] to the backend.
  Future<ApiResult<void>> updateNotificationPreferences(
    NotificationPreferencesEntity preferences,
  );
}
