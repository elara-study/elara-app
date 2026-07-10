import 'package:elara/core/network/api_result.dart';
import 'package:elara/features/notifications/domain/repositories/notification_repository.dart';

/// Marks multiple notifications identified by [notificationIds] as read on the backend.
///
/// PATCH `/api/v1/notifications/batch`
class MarkMultipleNotificationsReadUseCase {
  final NotificationRepository _repository;

  const MarkMultipleNotificationsReadUseCase(this._repository);

  Future<ApiResult<void>> call(List<String> notificationIds) =>
      _repository.markMultipleNotificationsRead(notificationIds);
}
