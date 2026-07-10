import 'package:elara/shared/domain/entities/group_entity.dart';

class StudentGroupEntity extends GroupEntity {
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
  final double progressPercent;
  @override
  final String colorKey;
  @override
  final int completedLessons;
  @override
  String get lessonProgressLabel => '$completedLessons/$totalLessons lessons';

  const StudentGroupEntity({
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
}
