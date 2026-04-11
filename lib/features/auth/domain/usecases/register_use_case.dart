import 'package:elara/core/enums/user_role.dart';
import 'package:elara/features/auth/domain/entities/user_entity.dart';
import 'package:elara/features/auth/domain/repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository _repository;

  RegisterUseCase(this._repository);

  Future<UserEntity> call({
    required String fullName,
    required String email,
    required String password,
    required UserRole role,
  }) {
    return _repository.register(
      fullName: fullName,
      email: email,
      password: password,
      role: role,
    );
  }
}
