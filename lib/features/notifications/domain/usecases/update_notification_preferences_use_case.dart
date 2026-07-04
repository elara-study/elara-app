import 'package:elara/core/network/api_result.dart';
import 'package:elara/features/notifications/domain/entities/notification_preferences_entity.dart';
import 'package:elara/features/notifications/domain/repositories/notification_repository.dart';

/// Updates the user's notification preferences on the backend.
///
/// PATCH `/api/v1/notifications/preferences`
class UpdateNotificationPreferencesUseCase {
  final NotificationRepository _repository;

  const UpdateNotificationPreferencesUseCase(this._repository);

  Future<ApiResult<void>> call(NotificationPreferencesEntity preferences) =>
      _repository.updateNotificationPreferences(preferences);
}
