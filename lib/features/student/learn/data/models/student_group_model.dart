import 'package:elara/features/student/learn/domain/entities/student_group.dart';

class StudentGroupModel {
  final String id;
  final String name;
  final String subject;
  final int grade;
  final String teacher;
  final int studentsCount;
  final int completedLessons;
  final int totalLessons;
  final double progressPercentage;

  const StudentGroupModel({
    required this.id,
    required this.name,
    required this.subject,
    required this.grade,
    required this.teacher,
    required this.studentsCount,
    required this.completedLessons,
    required this.totalLessons,
    required this.progressPercentage,
  });

  factory StudentGroupModel.fromJson(Map<String, dynamic> json) {
    final stats = json['stats'] as Map<String, dynamic>? ?? {};
    final lessons = stats['lessons'] as Map<String, dynamic>? ?? {};

    return StudentGroupModel(
      id: json['id'] as String,
      name: json['name'] as String,
      subject: json['subject'] as String,
      grade: (json['grade'] as num).toInt(),
      teacher: json['teacher'] as String,
      studentsCount: (stats['studentsCount'] as num?)?.toInt() ?? 0,
      completedLessons: (lessons['completed'] as num?)?.toInt() ?? 0,
      totalLessons: (lessons['total'] as num?)?.toInt() ?? 0,
      progressPercentage: (json['progressPercentage'] as num?)?.toDouble() ?? 0,
    );
  }

  StudentGroup toEntity() {
    return StudentGroup(
      id: id,
      name: name,
      subject: subject,
      grade: grade,
      teacher: teacher,
      stats: GroupStats(
        studentsCount: studentsCount,
        lessons: LessonStats(
          completed: completedLessons,
          total: totalLessons,
        ),
      ),
      progressPercentage: progressPercentage,
    );
  }
}
