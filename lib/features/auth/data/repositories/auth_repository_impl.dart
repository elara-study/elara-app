import 'dart:convert';

import 'package:elara/core/enums/user_role.dart';
import 'package:elara/core/error/exceptions.dart';
import 'package:elara/core/error/failures.dart';
import 'package:elara/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:elara/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:elara/features/auth/data/models/auth_model.dart';
import 'package:elara/features/auth/data/models/user_model.dart';
import 'package:elara/features/auth/domain/entities/user_entity.dart';
import 'package:elara/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;

  AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    required AuthLocalDataSource localDataSource,
  }) : _remoteDataSource = remoteDataSource,
       _localDataSource = localDataSource;

  @override
  Future<UserEntity> login({
    required String email,
    required String password,
  }) async {
    try {
      final user = await _remoteDataSource.login(
        LoginRequest(email: email, password: password),
      );
      await _localDataSource.cacheUser(user);
      return user;
    } on ServerException catch (e) {
      if (_isEmailNotVerifiedMessage(e.message)) {
        throw EmailNotVerifiedException(email: email);
      }
      throw ServerFailure(e.message);
    } on NetworkException catch (e) {
      throw NetworkFailure(e.message);
    } on EmailNotVerifiedException {
      rethrow;
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<RegisteredUserData> register({
    required String name,
    required String email,
    required String password,
    required UserRole role,
    required DateTime dateOfBirth,
    int? subjectId,
    int? grade,
  }) async {
    try {
      return await _remoteDataSource.register(
        RegisterRequest(
          name: name,
          email: email,
          password: password,
          role: role,
          dateOfBirth: dateOfBirth,
          subjectId: subjectId,
          grade: grade,
        ),
      );
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    } on NetworkException catch (e) {
      throw NetworkFailure(e.message);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<UserEntity> verifyEmail({
    required String email,
    required String otp,
    required UserEntity pendingUser,
  }) async {
    try {
      final response = await _remoteDataSource.verifyEmail(
        VerifyEmailRequest(email: email, otp: otp),
      );

      final payload = _decodeJwt(response.token);

      // Prefer JWT claims (always present after verify). Fall back to the
      // partial user from sign-up when login resumes an unverified account.
      final verifiedUser = UserModel(
        id:
            payload['nameid'] as String? ??
            payload['sub'] as String? ??
            pendingUser.id,
        fullName: payload['name'] as String? ?? pendingUser.fullName,
        email: payload['email'] as String? ?? pendingUser.email,
        role: _parseRole(
          payload['role'] as String? ?? pendingUser.role.name,
        ),
        token: response.token,
        refreshToken: response.refreshToken,
      );

      await _localDataSource.cacheUser(verifiedUser);
      return verifiedUser;
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    } on NetworkException catch (e) {
      throw NetworkFailure(e.message);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _localDataSource.clearUser();
    } on CacheException catch (e) {
      throw CacheFailure(e.message);
    }
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    try {
      final token = await _localDataSource.getAccessToken();
      if (token == null || token.isEmpty) {
        return null;
      }

      final remoteUser = await _remoteDataSource.getMe();
      final refreshToken = await _localDataSource.getRefreshToken();

      final user = UserModel(
        id: remoteUser.id,
        fullName: remoteUser.fullName,
        email: remoteUser.email,
        role: remoteUser.role,
        token: token,
        refreshToken: refreshToken,
      );

      await _localDataSource.cacheUser(user);
      return user;
    } on ServerException {
      await _localDataSource.clearUser();
      return null;
    } on NetworkException {
      final cached = await _localDataSource.getCachedUser();
      return cached;
    } on CacheException {
      return null;
    } catch (_) {
      await _localDataSource.clearUser();
      return null;
    }
  }

  @override
  Future<void> forgotPassword({required String email}) async {
    try {
      await _remoteDataSource.forgotPassword(
        ForgotPasswordRequest(email: email),
      );
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    } on NetworkException catch (e) {
      throw NetworkFailure(e.message);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<void> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    try {
      await _remoteDataSource.resetPassword(
        ResetPasswordRequest(
          email: email,
          otp: otp,
          newPassword: newPassword,
          confirmNewPassword: newPassword,
        ),
      );
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    } on NetworkException catch (e) {
      throw NetworkFailure(e.message);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<UserEntity> googleSignIn({required String idToken}) async {
    try {
      final response = await _remoteDataSource.googleSignIn(
        GoogleSignInRequest(token: idToken),
      );

      final payload = _decodeJwt(response.token);
      final roleStr = payload['role'] as String?;

      // No role claim → new user, needs to complete registration.
      if (roleStr == null || roleStr.isEmpty) {
        throw NeedsRoleException(
          pendingToken: response.token,
          refreshToken: response.refreshToken,
        );
      }

      // Existing user → build entity, cache, and return.
      final user = UserModel(
        id: payload['nameid'] as String? ?? payload['sub'] as String? ?? '',
        fullName: payload['name'] as String? ?? '',
        email: payload['email'] as String? ?? '',
        role: _parseRole(roleStr),
        token: response.token,
        refreshToken: response.refreshToken,
      );

      await _localDataSource.cacheUser(user);

      return user;
    } on NeedsRoleException {
      rethrow;
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    } on NetworkException catch (e) {
      throw NetworkFailure(e.message);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<UserEntity> completeRegistration({
    required String pendingToken,
    required UserRole role,
    required DateTime dateOfBirth,
    int? subjectId,
    int? grade,
  }) async {
    try {
      final response = await _remoteDataSource.completeRegistration(
        CompleteRegistrationRequest(
          pendingToken: pendingToken,
          role: role.name.substring(0, 1).toUpperCase() + role.name.substring(1),
          dateOfBirth: dateOfBirth,
          subjectId: subjectId,
          grade: grade,
        ),
      );

      final payload = _decodeJwt(response.token);

      final user = UserModel(
        id: payload['nameid'] as String? ?? payload['sub'] as String? ?? '',
        fullName: payload['name'] as String? ?? '',
        email: payload['email'] as String? ?? '',
        role: role,
        token: response.token,
        refreshToken: response.refreshToken,
      );

      await _localDataSource.cacheUser(user);

      return user;
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    } on NetworkException catch (e) {
      throw NetworkFailure(e.message);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  // ── Helpers ────────────────────────────────────────────────────────

  Map<String, dynamic> _decodeJwt(String token) {
    final parts = token.split('.');
    if (parts.length < 2) throw const FormatException('Invalid JWT');
    final normalized = base64Url.normalize(parts[1]);
    return jsonDecode(utf8.decode(base64Url.decode(normalized)))
        as Map<String, dynamic>;
  }

  bool _isEmailNotVerifiedMessage(String message) {
    final lower = message.toLowerCase();
    return lower.contains('verify') && lower.contains('email');
  }

  UserRole _parseRole(String roleStr) {
    switch (roleStr.toLowerCase()) {
      case 'student':
        return UserRole.student;
      case 'teacher':
        return UserRole.teacher;
      case 'parent':
        return UserRole.parent;
      default:
        return UserRole.student;
    }
  }
}
