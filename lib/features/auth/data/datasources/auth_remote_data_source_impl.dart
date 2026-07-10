import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:elara/core/constants/api_constants.dart';
import 'package:elara/core/enums/user_role.dart';
import 'package:elara/core/error/exceptions.dart';
import 'package:elara/core/network/dio_client.dart';
import 'package:elara/core/utils/logger.dart';
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
        refreshToken: data['refreshToken'] as String?,
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

      // Backend returns data:null on success — build from request fields.
      if (data == null) {
        return RegisteredUserData(
          userId: '',
          email: request.email,
          name: request.name,
          role: request.role.value,
        );
      }

      return RegisteredUserData.fromJson(data);
    } on DioException catch (e) {
      final data = e.response?.data;
      AppLogger.log(
        'Register error — status: ${e.response?.statusCode} | body: $data',
      );
      if (data is Map<String, dynamic>) {
        // Top-level message
        final msg = data['message'] as String?;
        if (msg != null && msg.isNotEmpty) throw ServerException(msg);

        // ASP.NET model validation: { "errors": { "FieldName": ["msg"] } }
        final errors = data['errors'];
        if (errors is Map<String, dynamic> && errors.isNotEmpty) {
          final first = errors.values.first;
          final detail = first is List && first.isNotEmpty
              ? first.first.toString()
              : first.toString();
          throw ServerException(detail);
        }

        // Standard ProblemDetails title fallback
        final title = data['title'] as String?;
        if (title != null && title.isNotEmpty) throw ServerException(title);
      }
      throw ServerException(e.message ?? 'Server connection error');
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(e.toString());
    }
  }

  @override
  Future<VerifyEmailResponse> verifyEmail(VerifyEmailRequest request) async {
    try {
      final response = await _dioClient.dio.post(
        ApiConstants.verifyEmail,
        data: request.toJson(),
      );

      final body = response.data;
      if (body == null || body is! Map<String, dynamic>) {
        throw ServerException('Invalid server response format');
      }

      final status = body['status'] as String?;
      if (status != null && status != 'Success') {
        throw ServerException(
          body['message'] as String? ?? 'Email verification failed',
        );
      }

      return VerifyEmailResponse.fromJson(body);
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
  Future<void> forgotPassword(ForgotPasswordRequest request) async {
    try {
      final response = await _dioClient.dio.post(
        ApiConstants.forgotPassword,
        data: request.toJson(),
      );

      final body = response.data;
      if (body is Map<String, dynamic>) {
        final status = body['status'] as String?;
        if (status != null && status != 'Success') {
          throw ServerException(
            body['message'] as String? ?? 'Failed to send OTP',
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

  @override
  Future<void> resetPassword(ResetPasswordRequest request) async {
    try {
      final response = await _dioClient.dio.post(
        ApiConstants.resetPassword,
        data: request.toJson(),
      );

      final body = response.data;
      if (body is Map<String, dynamic>) {
        final status = body['status'] as String?;
        if (status != null && status != 'Success') {
          throw ServerException(
            body['message'] as String? ?? 'Password reset failed',
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

  @override
  Future<OAuthTokenResponse> googleSignIn(GoogleSignInRequest request) async {
    try {
      final response = await _dioClient.dio.post(
        ApiConstants.googleSignIn,
        data: request.toJson(),
      );

      final body = response.data;
      AppLogger.log(
        'Google sign-in response — status: ${response.statusCode} | body: $body',
      );

      if (body == null || body is! Map<String, dynamic>) {
        throw ServerException('Invalid server response format');
      }

      final status = body['status'] as String?;
      if (status != null && status != 'Success') {
        throw ServerException(
          body['message'] as String? ?? 'Google sign-in failed',
        );
      }

      return OAuthTokenResponse.fromJson(body);
    } on DioException catch (e) {
      final data = e.response?.data;
      AppLogger.log(
        'Google sign-in error — status: ${e.response?.statusCode} | body: $data',
      );
      if (data is Map<String, dynamic>) {
        final msg = data['message'] as String?;
        if (msg != null && msg.isNotEmpty) throw ServerException(msg);
        final errors = data['errors'];
        if (errors is Map<String, dynamic> && errors.isNotEmpty) {
          final first = errors.values.first;
          final detail = first is List && first.isNotEmpty
              ? first.first.toString()
              : first.toString();
          throw ServerException(detail);
        }
      }
      throw ServerException(e.message ?? 'Server connection error');
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(e.toString());
    }
  }

  @override
  Future<OAuthTokenResponse> completeRegistration(
    CompleteRegistrationRequest request,
  ) async {
    try {
      final response = await _dioClient.dio.post(
        ApiConstants.completeRegistration,
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

      return OAuthTokenResponse.fromJson(body);
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
  Future<UserModel> getMe() async {
    try {
      final response = await _dioClient.dio.get(ApiConstants.authMe);

      final body = response.data;
      if (body == null || body is! Map<String, dynamic>) {
        throw ServerException('Invalid server response format');
      }

      final status = body['status'] as String?;
      if (status != null && status != 'Success') {
        throw ServerException(
          body['message'] as String? ?? 'Failed to load profile',
        );
      }

      final data = body['data'] as Map<String, dynamic>?;
      if (data == null) {
        throw ServerException('No profile data returned from server');
      }

      return UserModel(
        id: data['id'] as String? ??
            data['userId'] as String? ??
            data['nameid'] as String? ??
            '',
        fullName: data['name'] as String? ??
            data['fullName'] as String? ??
            data['full_name'] as String? ??
            '',
        email: data['email'] as String? ?? '',
        role: _parseRole(
          data['role'] as String? ?? data['userRole'] as String? ?? '',
        ),
        token: '',
        phone: data['phone'] as String? ??
            data['Phone'] as String? ??
            data['phoneNumber'] as String? ??
            data['PhoneNumber'] as String?,
      );
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;
      if (statusCode == 401 || statusCode == 403) {
        throw ServerException('Session expired');
      }
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
  Future<RefreshTokenResponse> refreshToken(RefreshTokenRequest request) async {
    try {
      final response = await _dioClient.dio.post(
        ApiConstants.refreshToken,
        data: request.toJson(),
      );

      final body = response.data;
      if (body == null || body is! Map<String, dynamic>) {
        throw ServerException('Invalid server response format');
      }

      final status = body['status'] as String?;
      if (status != 'Success') {
        throw ServerException(
          body['message'] as String? ?? 'Token refresh failed',
        );
      }

      return RefreshTokenResponse.fromJson(body);
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
