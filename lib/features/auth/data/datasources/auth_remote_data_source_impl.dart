import 'dart:async';
import 'package:elara/core/enums/user_role.dart';
import 'package:elara/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:elara/features/auth/data/models/auth_model.dart';
import 'package:elara/features/auth/data/models/user_model.dart';

/// MOCKED implementation — replace body of [login] and [register]
/// with real Dio calls once the backend is ready.
///
/// To switch to real API:
///   1. Inject [DioClient] via constructor.
///   2. Replace the `await Future.delayed(...)` blocks with Dio calls.
///   3. Parse the response using [UserModel.fromJson].
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  //   inject DioClient when backend is ready
  // final DioClient _dioClient;
  // AuthRemoteDataSourceImpl(this._dioClient);

  AuthRemoteDataSourceImpl();

  @override
  Future<UserModel> login(LoginRequest request) async {
    // ── MOCK ────────────────────────────────────────────────────────────────
    await Future.delayed(const Duration(milliseconds: 1200));

    // Simulate a simple validation
    if (request.email.isEmpty || request.password.isEmpty) {
      throw Exception('Invalid credentials');
    }

    return UserModel(
      id: 'mock-user-001',
      fullName: 'Mock User',
      email: request.email,
      role: UserRole.student,
      token: 'mock-jwt-token-login-${DateTime.now().millisecondsSinceEpoch}',
    );
    // ── REAL (uncomment when backend ready) ─────────────────────────────────
    // try {
    //   final response = await _dioClient.dio.post(
    //     ApiConstants.login,
    //     data: request.toJson(),
    //   );
    //   return UserModel.fromJson(response.data as Map<String, dynamic>);
    // } on DioException catch (e) {
    //   throw ServerException(e.message ?? 'Login failed');
    // }
  }

  @override
  Future<UserModel> register(RegisterRequest request) async {
    // ── MOCK ────────────────────────────────────────────────────────────────
    await Future.delayed(const Duration(milliseconds: 1200));

    return UserModel(
      id: 'mock-user-002',
      fullName: request.fullName,
      email: request.email,
      role: request.role,
      token: 'mock-jwt-token-register-${DateTime.now().millisecondsSinceEpoch}',
    );
    // ── REAL (uncomment when backend ready) ─────────────────────────────────
    // try {
    //   final response = await _dioClient.dio.post(
    //     ApiConstants.register,
    //     data: request.toJson(),
    //   );
    //   return UserModel.fromJson(response.data as Map<String, dynamic>);
    // } on DioException catch (e) {
    //   throw ServerException(e.message ?? 'Registration failed');
    // }
  }
}
