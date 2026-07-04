import 'package:elara/core/network/api_result.dart';
import 'package:elara/features/notifications/domain/repositories/notification_repository.dart';

/// Returns the number of unread notifications from the backend.
///
/// GET `/api/v1/notifications/unread-count`
class GetUnreadCountUseCase {
  final NotificationRepository _repository;

  const GetUnreadCountUseCase(this._repository);

  Future<ApiResult<int>> call() => _repository.getUnreadCount();
}
