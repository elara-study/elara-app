import 'package:elara/core/enums/user_role.dart';
import 'package:elara/features/auth/data/models/auth_model.dart';
import 'package:elara/features/auth/domain/repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository _repository;

  RegisterUseCase(this._repository);

  Future<RegisteredUserData> call({
    required String name,
    required String email,
    required String password,
    required UserRole role,
    required DateTime dateOfBirth,
    int? subjectId,
    int? grade,
  }) {
    return _repository.register(
      name: name,
      email: email,
      password: password,
      role: role,
      dateOfBirth: dateOfBirth,
      subjectId: subjectId,
      grade: grade,
    );
  }
}
