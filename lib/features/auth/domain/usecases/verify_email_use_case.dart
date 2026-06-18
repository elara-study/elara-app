import 'package:elara/features/auth/domain/entities/user_entity.dart';
import 'package:elara/features/auth/domain/repositories/auth_repository.dart';

class VerifyEmailUseCase {
  final AuthRepository _repository;

  VerifyEmailUseCase(this._repository);

  Future<UserEntity> call({
    required String email,
    required String otp,
    required UserEntity pendingUser,
  }) {
    return _repository.verifyEmail(
      email: email,
      otp: otp,
      pendingUser: pendingUser,
    );
  }
}

