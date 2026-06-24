import 'package:elara/features/auth/domain/entities/user_entity.dart';
import 'package:elara/features/auth/domain/repositories/auth_repository.dart';

class GoogleSignInUseCase {
  final AuthRepository _repository;

  GoogleSignInUseCase(this._repository);

  Future<UserEntity> call({required String idToken}) {
    return _repository.googleSignIn(idToken: idToken);
  }
}
