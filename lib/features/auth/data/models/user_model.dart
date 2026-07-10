import 'package:elara/core/enums/user_role.dart';
import 'package:elara/features/auth/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.fullName,
    required super.email,
    required super.role,
    required super.token,
    super.refreshToken,
    super.phone,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      fullName: json['full_name'] as String,
      email: json['email'] as String,
      role: UserRole.values.firstWhere(
        (r) => r.value == (json['role'] as String),
        orElse: () => UserRole.student,
      ),
      token: json['token'] as String,
      refreshToken: json['refresh_token'] as String?,
      phone: json['phone'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'email': email,
      'role': role.value,
      'token': token,
      if (refreshToken != null) 'refresh_token': refreshToken,
      if (phone != null) 'phone': phone,
    };
  }

  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      id: entity.id,
      fullName: entity.fullName,
      email: entity.email,
      role: entity.role,
      token: entity.token,
      refreshToken: entity.refreshToken,
      phone: entity.phone,
    );
  }
}

