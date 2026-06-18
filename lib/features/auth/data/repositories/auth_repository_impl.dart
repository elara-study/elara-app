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
      throw ServerFailure(e.message);
    } on NetworkException catch (e) {
      throw NetworkFailure(e.message);
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

      // Reconstruct the full entity: real token + refreshToken from the API,
      // all other identity fields from the partial user saved at register time.
      final verifiedUser = UserModel(
        id: pendingUser.id,
        fullName: pendingUser.fullName,
        email: pendingUser.email,
        role: pendingUser.role,
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
      return await _localDataSource.getCachedUser();
    } on CacheException catch (_) {
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
}
