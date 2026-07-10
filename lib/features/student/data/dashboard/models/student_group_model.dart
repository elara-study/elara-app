import 'package:elara/features/student/domain/dashboard/entities/student_group_entity.dart';

class StudentGroupModel extends StudentGroupEntity {
  const StudentGroupModel({
    required super.id,
    required super.name,
    required super.subject,
    required super.grade,
    required super.teacherName,
    required super.studentCount,
    required super.totalLessons,
    required super.completedLessons,
    required super.progressPercent,
    required super.colorKey,
  });

  factory StudentGroupModel.fromJson(Map<String, dynamic> json) {
    final stats = json['stats'] as Map<String, dynamic>? ?? {};
    final lessons = stats['lessons'] as Map<String, dynamic>? ?? {};
    final completed = (lessons['completed'] as num?)?.toInt() ?? 0;
    final total = (lessons['total'] as num?)?.toInt() ?? 0;
    final progress = (json['progressPercentage'] as num?)?.toDouble() ?? 0.0;
    final gradeInt = (json['grade'] as num?)?.toInt() ?? 0;

    return StudentGroupModel(
      id: json['id'] as String,
      name: json['name'] as String,
      subject: json['subject'] as String,
      grade: 'Grade $gradeInt',
      teacherName: json['teacher'] as String? ?? '',
      studentCount: (stats['studentsCount'] as num?)?.toInt() ?? 0,
      totalLessons: total,
      completedLessons: completed,
      progressPercent: progress / 100,
      colorKey: json['colorKey'] as String? ?? 'blue',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'subject': subject,
    'grade': grade,
    'teacher_name': teacherName,
    'student_count': studentCount,
    'total_lessons': totalLessons,
    'completed_lessons': completedLessons,
    'progress_percent': progressPercent,
    'color_key': colorKey,
  };
}
