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

  /// Verifies the OTP. Backend now returns token + refreshToken.
  /// [pendingUser] carries the partial user from register so the repository
  /// can reconstruct a full [UserEntity] (with real token + role) and cache it.
  Future<UserEntity> verifyEmail({
    required String email,
    required String otp,
    required UserEntity pendingUser,
  });

  Future<void> logout();

  Future<UserEntity?> getCurrentUser();

  Future<void> forgotPassword({required String email});

  Future<void> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  });

  /// Sends the Google ID token to the backend. Returns the JWT.
  /// If the JWT has a role → existing user (return UserEntity).
  /// If no role → new user (throws a specific exception carrying the pending token).
  Future<UserEntity> googleSignIn({required String idToken});

  /// Completes registration for a Google-authenticated user who has no role yet.
  Future<UserEntity> completeRegistration({
    required String pendingToken,
    required UserRole role,
    required DateTime dateOfBirth,
    int? subjectId,
    int? grade,
  });
}
