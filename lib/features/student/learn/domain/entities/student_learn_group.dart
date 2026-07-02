import 'package:elara/shared/domain/entities/group_entity.dart';

class StudentLearnGroup extends GroupEntity {
  const StudentLearnGroup({
    required this.id,
    required this.name,
    required this.subject,
    required this.grade,
    required this.teacherName,
    required this.studentCount,
    required this.totalLessons,
    required this.completedLessons,
    required this.progressPercent,
    required this.colorKey,
  });

  @override
  final String id;
  @override
  final String name;
  @override
  final String subject;
  @override
  final String grade;
  @override
  final String teacherName;
  @override
  final int studentCount;
  @override
  final int totalLessons;
  @override
  final int completedLessons;
  @override
  final double progressPercent;
  @override
  final String colorKey;

  @override
  String get lessonProgressLabel => '$completedLessons/$totalLessons lessons';
}
