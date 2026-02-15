import 'package:equatable/equatable.dart';

enum UserRole { teacher, student, parent }

class User extends Equatable {
  const User({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
  });

  final String id;
  final String email;
  final String name;
  final UserRole role;

  @override
  List<Object?> get props => [id, email, name, role];
}
