import 'package:elara/features/auth/domain/repositories/auth_repository.dart';

class VerifyEmailUseCase {
  final AuthRepository _repository;

  VerifyEmailUseCase(this._repository);

  Future<void> call({required String email, required String otp}) {
    return _repository.verifyEmail(email: email, otp: otp);
  }
}
