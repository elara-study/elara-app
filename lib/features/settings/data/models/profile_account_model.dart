import 'package:elara/features/settings/domain/entities/profile_account_entity.dart';

/// DTO for [ProfileAccountEntity] (snake_case JSON when API exists).
class ProfileAccountModel {
  const ProfileAccountModel({
    required this.fullName,
    required this.username,
    required this.email,
    required this.grade,
    required this.country,
  });

  factory ProfileAccountModel.fromJson(Map<String, dynamic> json) {
    return ProfileAccountModel(
      fullName: json['full_name'] as String,
      username: json['username'] as String,
      email: json['email'] as String,
      grade: json['grade'] as String,
      country: json['country'] as String,
    );
  }

  final String fullName;
  final String username;
  final String email;
  final String grade;
  final String country;

  ProfileAccountEntity toEntity() => ProfileAccountEntity(
    fullName: fullName,
    username: username,
    email: email,
    grade: grade,
    country: country,
  );
}
