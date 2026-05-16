import 'package:equatable/equatable.dart';

/// Account fields shown on Profile & Account (all roles).
class ProfileAccountEntity extends Equatable {
  const ProfileAccountEntity({
    required this.fullName,
    required this.username,
    required this.email,
    required this.grade,
    required this.country,
  });

  final String fullName;
  final String username;
  final String email;
  final String grade;
  final String country;

  @override
  List<Object?> get props => [fullName, username, email, grade, country];
}
