import 'package:elara/core/network/api_result.dart';
import 'package:elara/features/notifications/domain/repositories/notification_repository.dart';

/// Registers the device's FCM token with the backend.
///
/// Call this once after [NotificationService.getToken()] resolves and
/// again from [NotificationService.onTokenRefresh] to keep the backend
/// in sync after token rotations.
///
/// POST `/api/v1/notifications/device-token`
class RegisterDeviceTokenUseCase {
  final NotificationRepository _repository;

  const RegisterDeviceTokenUseCase(this._repository);

  Future<ApiResult<void>> call(String token) =>
      _repository.registerDeviceToken(token);
}
