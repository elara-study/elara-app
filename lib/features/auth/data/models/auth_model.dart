import 'package:elara/core/enums/user_role.dart';

/// Request/Response DTOs for Auth endpoints

class LoginRequest {
  final String email;
  final String password;

  const LoginRequest({required this.email, required this.password});

  Map<String, dynamic> toJson() => {
    'email': email,
    'password': password,
  };
}

class RegisterRequest {
  final String fullName;
  final String email;
  final String password;
  final UserRole role;

  const RegisterRequest({
    required this.fullName,
    required this.email,
    required this.password,
    required this.role,
  });

  Map<String, dynamic> toJson() => {
    'full_name': fullName,
    'email': email,
    'password': password,
    'role': role.value,
  };
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
