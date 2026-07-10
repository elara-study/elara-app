import 'package:equatable/equatable.dart';

class TeacherRoadmapModuleEntity extends Equatable {
  final String id;
  final String title;
  final String description;

  const TeacherRoadmapModuleEntity({
    required this.id,
    required this.title,
    required this.description,
  });

  @override
  List<Object?> get props => [id, title, description];
}

class TeacherRoadmapEntity extends Equatable {
  final String id;
  final String name;
  final String description;
  final int grade;
  final String subject;
  final DateTime createdAt;
  final List<TeacherRoadmapModuleEntity> modules;

  const TeacherRoadmapEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.grade,
    required this.subject,
    required this.createdAt,
    required this.modules,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        grade,
        subject,
        createdAt,
        modules,
      ];
}
