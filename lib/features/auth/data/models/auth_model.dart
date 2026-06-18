import 'package:elara/core/enums/user_role.dart';

/// Request/Response DTOs for Auth endpoints

class LoginRequest {
  final String email;
  final String password;

  const LoginRequest({required this.email, required this.password});

  Map<String, dynamic> toJson() => {'email': email, 'password': password};
}

class RegisterRequest {
  final String name;
  final String email;
  final String password;
  final UserRole role;
  final DateTime dateOfBirth;
  final int? subjectId;
  final int? grade;

  const RegisterRequest({
    required this.name,
    required this.email,
    required this.password,
    required this.role,
    required this.dateOfBirth,
    this.subjectId,
    this.grade,
  });

  Map<String, dynamic> toJson() {
    final formatted =
        '${dateOfBirth.year.toString().padLeft(4, '0')}'
        '-${dateOfBirth.month.toString().padLeft(2, '0')}'
        '-${dateOfBirth.day.toString().padLeft(2, '0')}';
    return {
      'name': name,
      'email': email,
      'password': password,
      'confirmPassword': password,
      'dateOfBirth': formatted,
      'role': role.value,
      if (subjectId != null) 'subjectId': subjectId,
      if (grade != null) 'grade': grade,
    };
  }
}

class AuthResponse {
  final String id;
  final String fullName;
  final String email;
  final String role;
  final String token;

  const AuthResponse({
    required this.id,
    required this.fullName,
    required this.email,
    required this.role,
    required this.token,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      id: json['id'] as String,
      fullName: json['full_name'] as String,
      email: json['email'] as String,
      role: json['role'] as String,
      token: json['token'] as String,
    );
  }
}

/// POST /api/v1/Auth/verify-email request body.
class VerifyEmailRequest {
  final String email;
  final String otp;

  const VerifyEmailRequest({required this.email, required this.otp});

  Map<String, dynamic> toJson() => {'email': email, 'otp': otp};
}

/// POST /api/v1/Auth/verify-email — response body.
/// Backend shape:
/// { "status": "Success", "data": { "token": "...", "refreshToken": "..." } }
class VerifyEmailResponse {
  final String token;
  final String refreshToken;

  const VerifyEmailResponse({required this.token, required this.refreshToken});

  factory VerifyEmailResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    return VerifyEmailResponse(
      token: data['token'] as String,
      refreshToken: data['refreshToken'] as String,
    );
  }
}

/// Minimal user data returned by the register endpoint
/// (no token yet — token is issued after email verification + login).
class RegisteredUserData {
  final String userId;
  final String email;
  final String name;
  final String role;

  const RegisteredUserData({
    required this.userId,
    required this.email,
    required this.name,
    required this.role,
  });

  factory RegisteredUserData.fromJson(Map<String, dynamic> json) =>
      RegisteredUserData(
        userId: json['userId'] as String? ?? '',
        email: json['email'] as String? ?? '',
        name: json['name'] as String? ?? '',
        role: json['role'] as String? ?? '',
      );
}

/// POST /api/v1/Auth/refresh — request body.
class RefreshTokenRequest {
  final String refreshToken;

  const RefreshTokenRequest({required this.refreshToken});

  Map<String, dynamic> toJson() => {'refreshToken': refreshToken};
}

/// POST /api/v1/Auth/refresh — response body.
/// Shape: { "status": "Success", "data": { "token": "...", "refreshToken": "..." } }
class RefreshTokenResponse {
  final String token;
  final String refreshToken;

  const RefreshTokenResponse({
    required this.token,
    required this.refreshToken,
  });

  factory RefreshTokenResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    return RefreshTokenResponse(
      token: data['token'] as String,
      refreshToken: data['refreshToken'] as String,
    );
  }
}

/// POST /api/v1/Auth/forgot-password — request body.
class ForgotPasswordRequest {
  final String email;

  const ForgotPasswordRequest({required this.email});

  Map<String, dynamic> toJson() => {'email': email};
}

/// POST /api/v1/Auth/reset-password — request body.
class ResetPasswordRequest {
  final String email;
  final String otp;
  final String newPassword;
  final String confirmNewPassword;

  const ResetPasswordRequest({
    required this.email,
    required this.otp,
    required this.newPassword,
    required this.confirmNewPassword,
  });

  Map<String, dynamic> toJson() => {
    'email': email,
    'otp': otp,
    'newPassword': newPassword,
    'confirmNewPassword': confirmNewPassword,
  };
}

