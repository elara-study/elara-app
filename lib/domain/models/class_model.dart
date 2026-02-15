import 'package:equatable/equatable.dart';

class ClassModel extends Equatable {
  const ClassModel({
    required this.id,
    required this.name,
    required this.code,
    this.description,
    this.studentCount = 0,
  });

  final String id;
  final String name;
  final String code;
  final String? description;
  final int studentCount;

  @override
  List<Object?> get props => [id, name, code, description, studentCount];
}
