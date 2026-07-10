import 'package:elara/features/notifications/data/models/notification_model.dart';
import 'package:elara/features/notifications/data/models/notification_preferences_model.dart';

/// Abstract contract for all notification-related network operations.
///
/// Returns concrete model types; the repository maps them to entities.
/// This interface exists so the implementation can be swapped (e.g. for a
/// mock in tests) without changing any caller code.
abstract class NotificationRemoteDataSource {
  // ── Device token ────────────────────────────────────────────────────────────

  /// Registers [token] with the backend.
  /// POST `/api/v1/notifications/device-token`
  Future<void> registerDeviceToken(String token);

  /// Removes [token] from the backend (e.g. on sign-out).
  /// DELETE `/api/v1/notifications/device-token`
  Future<void> removeDeviceToken(String token);

  // ── Notification list ────────────────────────────────────────────────────────

  /// Fetches a paginated list of notifications.
  /// GET `/api/v1/notifications?page=&limit=`
  Future<List<NotificationModel>> getNotifications({
    required int page,
    required int limit,
  });

  /// Marks all notifications as read.
  /// PATCH `/api/v1/notifications`
  Future<void> markAllNotificationsRead();

  /// Returns the number of unread notifications.
  /// GET `/api/v1/notifications/unread-count`
  Future<int> getUnreadCount();

  /// Marks a single notification as read.
  /// PATCH `/api/v1/notifications/{id}`
  Future<void> markNotificationRead(String id);

  /// Marks multiple notifications as read.
  /// PATCH `/api/v1/notifications/batch`
  Future<void> markMultipleNotificationsRead(List<String> ids);

  // ── Preferences ─────────────────────────────────────────────────────────────

  /// Returns the user's current notification preference settings.
  /// GET `/api/v1/notifications/preferences`
  Future<NotificationPreferencesModel> getNotificationPreferences();

  /// Updates the user's notification preference settings.
  /// PATCH `/api/v1/notifications/preferences`
  Future<void> updateNotificationPreferences(
    NotificationPreferencesModel preferences,
  );
}
