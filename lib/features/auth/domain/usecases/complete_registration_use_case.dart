import 'package:elara/core/enums/user_role.dart';
import 'package:elara/features/auth/domain/entities/user_entity.dart';
import 'package:elara/features/auth/domain/repositories/auth_repository.dart';

class CompleteRegistrationUseCase {
  final AuthRepository _repository;

  CompleteRegistrationUseCase(this._repository);

  Future<UserEntity> call({
    required String pendingToken,
    required UserRole role,
    required DateTime dateOfBirth,
    int? subjectId,
    int? grade,
  }) {
    return _repository.completeRegistration(
      pendingToken: pendingToken,
      role: role,
      dateOfBirth: dateOfBirth,
      subjectId: subjectId,
      grade: grade,
    );
  }
}
