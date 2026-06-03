import 'package:elara/core/enums/user_role.dart';
import 'package:elara/features/auth/data/models/auth_model.dart';
import 'package:elara/features/auth/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity> login({required String email, required String password});

  Future<RegisteredUserData> register({
    required String name,
    required String email,
    required String password,
    required UserRole role,
    required DateTime dateOfBirth,
    int? subjectId,
    int? grade,
  });

  Future<void> verifyEmail({required String email, required String otp});

  Future<void> logout();

  Future<UserEntity?> getCurrentUser();
}
