import 'package:elara/core/network/api_result.dart';
import 'package:elara/features/notifications/domain/repositories/notification_repository.dart';

/// Marks all notifications as read on the server.
///
/// PATCH `/api/v1/notifications`
class MarkAllNotificationsReadUseCase {
  final NotificationRepository _repository;

  const MarkAllNotificationsReadUseCase(this._repository);

  Future<ApiResult<void>> call() => _repository.markAllNotificationsRead();
}
