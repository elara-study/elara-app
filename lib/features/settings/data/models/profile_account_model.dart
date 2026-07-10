import 'package:elara/features/settings/domain/entities/profile_account_entity.dart';

/// DTO for [ProfileAccountEntity] (snake_case JSON when API exists).
class ProfileAccountModel {
  const ProfileAccountModel({
    required this.fullName,
    required this.username,
    required this.email,
    this.grade,
    this.country,
    this.phoneNumber,
    this.subjects,
  });

  factory ProfileAccountModel.fromJson(Map<String, dynamic> json) {
    return ProfileAccountModel(
      fullName: json['full_name'] as String,
      username: json['username'] as String,
      email: json['email'] as String,
      grade: json['grade'] as String?,
      country: json['country'] as String?,
      phoneNumber: json['phone_number'] as String?,
      subjects: (json['subjects'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );
  }

  final String fullName;
  final String username;
  final String email;
  final String? grade;
  final String? country;
  final String? phoneNumber;
  final List<String>? subjects;

  ProfileAccountEntity toEntity() => ProfileAccountEntity(
    fullName: fullName,
    username: username,
    email: email,
    grade: grade,
    country: country,
    phoneNumber: phoneNumber,
    subjects: subjects,
  );
}
