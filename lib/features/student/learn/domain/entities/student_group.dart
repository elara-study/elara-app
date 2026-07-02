import 'package:elara/features/student/domain/dashboard/entities/student_group_entity.dart';

class LessonStats {
  final int completed;
  final int total;

  const LessonStats({required this.completed, required this.total});
}

class GroupStats {
  final int studentsCount;
  final LessonStats lessons;

  const GroupStats({required this.studentsCount, required this.lessons});
}

class StudentGroup {
  final String id;
  final String name;
  final String subject;
  final int grade;
  final String teacher;
  final GroupStats stats;
  final double progressPercentage;

  const StudentGroup({
    required this.id,
    required this.name,
    required this.subject,
    required this.grade,
    required this.teacher,
    required this.stats,
    required this.progressPercentage,
  });

  StudentGroupEntity toStudentGroupEntity() {
    final progress = progressPercentage > 1
        ? progressPercentage / 100
        : progressPercentage;

    return StudentGroupEntity(
      id: id,
      name: name,
      subject: subject,
      grade: 'Grade $grade',
      teacherName: teacher,
      studentCount: stats.studentsCount,
      totalLessons: stats.lessons.total,
      completedLessons: stats.lessons.completed,
      progressPercent: progress,
      colorKey: _colorKeyFromSubject(subject),
    );
  }
}

String _colorKeyFromSubject(String subject) {
  final normalized = subject.toLowerCase();
  if (normalized.contains('english') || normalized.contains('literature')) {
    return 'green';
  }
  if (normalized.contains('science') ||
      normalized.contains('physics') ||
      normalized.contains('chemistry')) {
    return 'orange';
  }
  return 'blue';
}
