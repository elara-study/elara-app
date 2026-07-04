import 'package:elara/core/network/api_result.dart';
import 'package:elara/features/notifications/domain/entities/notification_entity.dart';
import 'package:elara/features/notifications/domain/repositories/notification_repository.dart';

/// Fetches a paginated list of notifications from the notification center.
///
/// GET `/api/v1/notifications?page=&limit=`
class GetNotificationsUseCase {
  final NotificationRepository _repository;

  const GetNotificationsUseCase(this._repository);

  Future<ApiResult<List<NotificationEntity>>> call({
    required int page,
    required int limit,
  }) => _repository.getNotifications(page: page, limit: limit);
}
