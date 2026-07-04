import 'package:elara/core/network/api_result.dart';
import 'package:elara/features/notifications/domain/repositories/notification_repository.dart';

/// Marks a single notification identified by [id] as read on the backend.
///
/// PATCH `/api/v1/notifications/{id}`
class MarkNotificationReadUseCase {
  final NotificationRepository _repository;

  const MarkNotificationReadUseCase(this._repository);

  Future<ApiResult<void>> call(String id) => _repository.markNotificationRead(id);
}
