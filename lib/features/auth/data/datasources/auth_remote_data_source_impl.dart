import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:elara/core/constants/api_constants.dart';
import 'package:elara/core/enums/user_role.dart';
import 'package:elara/core/error/exceptions.dart';
import 'package:elara/core/network/dio_client.dart';
import 'package:elara/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:elara/features/auth/data/models/auth_model.dart';
import 'package:elara/features/auth/data/models/user_model.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final DioClient _dioClient;

  AuthRemoteDataSourceImpl(this._dioClient);

  @override
  Future<UserModel> login(LoginRequest request) async {
    try {
      final response = await _dioClient.dio.post(
        ApiConstants.login,
        data: request.toJson(),
      );

      final body = response.data;
      if (body == null || body is! Map<String, dynamic>) {
        throw ServerException('Invalid server response format');
      }

      final status = body['status'] as String?;
      if (status != 'Success') {
        throw ServerException(body['message'] as String? ?? 'Login failed');
      }

      final data = body['data'] as Map<String, dynamic>?;
      if (data == null) {
        throw ServerException('No data returned from server');
      }

      final token = data['token'] as String?;
      if (token == null || token.isEmpty) {
        throw ServerException('Authentication token not received');
      }

      final payload = _decodeJwt(token);

      return UserModel(
        id: payload['nameid'] as String? ?? payload['sub'] as String? ?? '',
        fullName: payload['name'] as String? ?? '',
        email: payload['email'] as String? ?? request.email,
        role: _parseRole(payload['role'] as String? ?? ''),
        token: token,
      );
    } on DioException catch (e) {
      final data = e.response?.data;
      if (data is Map<String, dynamic> && data['message'] != null) {
        throw ServerException(data['message'] as String);
      }
      throw ServerException(e.message ?? 'Server connection error');
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(e.toString());
    }
  }

  @override
  Future<RegisteredUserData> register(RegisterRequest request) async {
    try {
      final response = await _dioClient.dio.post(
        ApiConstants.register,
        data: request.toJson(),
      );

      final body = response.data;
      if (body == null || body is! Map<String, dynamic>) {
        throw ServerException('Invalid server response format');
      }

      final status = body['status'] as String?;
      if (status != null && status != 'Success') {
        throw ServerException(
          body['message'] as String? ?? 'Registration failed',
        );
      }

      final data = body['data'] as Map<String, dynamic>?;
      if (data == null) {
        throw ServerException('No data returned from server');
      }

      return RegisteredUserData.fromJson(data);
    } on DioException catch (e) {
      final data = e.response?.data;
      if (data is Map<String, dynamic> && data['message'] != null) {
        throw ServerException(data['message'] as String);
      }
      throw ServerException(e.message ?? 'Server connection error');
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> verifyEmail(VerifyEmailRequest request) async {
    try {
      final response = await _dioClient.dio.post(
        ApiConstants.verifyEmail,
        data: request.toJson(),
      );

      final body = response.data;
      if (body is Map<String, dynamic>) {
        final status = body['status'] as String?;
        if (status != null && status != 'Success') {
          throw ServerException(
            body['message'] as String? ?? 'Email verification failed',
          );
        }
      }
    } on DioException catch (e) {
      final data = e.response?.data;
      if (data is Map<String, dynamic> && data['message'] != null) {
        throw ServerException(data['message'] as String);
      }
      throw ServerException(e.message ?? 'Server connection error');
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(e.toString());
    }
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

  Map<String, dynamic> _decodeJwt(String token) {
    try {
      final parts = token.split('.');
      if (parts.length < 2) {
        throw const FormatException('Invalid JWT structure');
      }
      final payload = parts[1];
      final normalized = base64Url.normalize(payload);
      final decodedBytes = base64Url.decode(normalized);
      final decodedStr = utf8.decode(decodedBytes);
      return jsonDecode(decodedStr) as Map<String, dynamic>;
    } catch (e) {
      throw const FormatException('Failed to decode JWT payload');
    }
  }
}
