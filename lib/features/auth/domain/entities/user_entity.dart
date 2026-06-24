import 'package:equatable/equatable.dart';
import 'package:elara/core/enums/user_role.dart';

class UserEntity extends Equatable {
  final String id;
  final String fullName;
  final String email;
  final UserRole role;
  final String token;
  // Null until verifyEmail or login issues the refresh token.
  final String? refreshToken;

  const UserEntity({
    required this.id,
    required this.fullName,
    required this.email,
    required this.role,
    required this.token,
    this.refreshToken,
  });

  @override
  List<Object?> get props => [id, fullName, email, role, token, refreshToken];
}
