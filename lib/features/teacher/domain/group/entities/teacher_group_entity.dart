import 'package:elara/shared/domain/entities/group_entity.dart';

class TeacherGroupEntity extends GroupEntity {
  @override
  final String id;
  @override
  final String name;
  @override
  final String subject;
  @override
  final String grade;
  @override
  final int studentCount;
  @override
  final int totalLessons;
  @override
  final double progressPercent;
  @override
  final String colorKey;
  @override
  String get lessonProgressLabel => '$totalLessons lessons';

  TeacherGroupEntity({
    required this.id,
    required this.name,
    required this.subject,
    required this.grade,
    required this.studentCount,
    required this.totalLessons,
    required this.progressPercent,
    required this.colorKey,
  });
}
