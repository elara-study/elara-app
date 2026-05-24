import 'package:equatable/equatable.dart';

/// Account fields shown on Profile & Account (all roles).
class ProfileAccountEntity extends Equatable {
  const ProfileAccountEntity({
    required this.fullName,
    required this.username,
    required this.email,
    this.grade,
    this.country,
    this.phoneNumber,
    this.subjects,
  });

  final String fullName;
  final String username;
  final String email;
  final String? grade;
  final String? country;
  final String? phoneNumber;
  final List<String>? subjects;

  @override
  List<Object?> get props => [fullName, username, email, grade, country, phoneNumber, subjects];
}
