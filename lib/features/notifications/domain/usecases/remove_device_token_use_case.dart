import 'package:elara/core/network/api_result.dart';
import 'package:elara/features/notifications/domain/repositories/notification_repository.dart';

/// Removes the device's FCM token from the backend.
///
/// Call this on sign-out so the server stops sending push notifications
/// to this device.
///
/// DELETE `/api/v1/notifications/device-token`
class RemoveDeviceTokenUseCase {
  final NotificationRepository _repository;

  const RemoveDeviceTokenUseCase(this._repository);

  Future<ApiResult<void>> call(String token) =>
      _repository.removeDeviceToken(token);
}
