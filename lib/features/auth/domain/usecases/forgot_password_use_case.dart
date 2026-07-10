import 'package:elara/features/auth/domain/repositories/auth_repository.dart';

class ForgotPasswordUseCase {
  final AuthRepository _repository;

  ForgotPasswordUseCase(this._repository);

  Future<void> call({required String email}) {
    return _repository.forgotPassword(email: email);
  }
}
