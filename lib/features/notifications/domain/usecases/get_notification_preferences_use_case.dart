import 'package:elara/core/network/api_result.dart';
import 'package:elara/features/notifications/domain/entities/notification_preferences_entity.dart';
import 'package:elara/features/notifications/domain/repositories/notification_repository.dart';

/// Retrieves the user's notification preferences from the backend.
///
/// GET `/api/v1/notifications/preferences`
class GetNotificationPreferencesUseCase {
  final NotificationRepository _repository;

  const GetNotificationPreferencesUseCase(this._repository);

  Future<ApiResult<NotificationPreferencesEntity>> call() =>
      _repository.getNotificationPreferences();
}
