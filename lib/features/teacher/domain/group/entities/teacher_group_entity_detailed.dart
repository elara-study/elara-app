import 'package:elara/shared/domain/entities/group_entity.dart';
import 'package:equatable/equatable.dart';

class TeacherGroupEntity extends GroupEntity with EquatableMixin {
  @override
  final String id;
  @override
  final String name;
  @override
  final String grade; // Shared entity expects String
  @override
  final String subject;
  final String? roadmapName;
  @override
  final int studentCount;
  @override
  final int totalLessons;
  @override
  final double progressPercent;
  @override
  final String colorKey;

  const TeacherGroupEntity({
    this.id = '',
    required this.name,
    required this.grade,
    required this.subject,
    this.roadmapName,
    this.studentCount = 0,
    this.totalLessons = 0,
    this.progressPercent = 0.0,
    this.colorKey = 'blue',
  });

  @override
  List<Object?> get props => [
        id,
        name,
        grade,
        subject,
        roadmapName,
        studentCount,
        totalLessons,
        progressPercent,
        colorKey,
      ];
}
