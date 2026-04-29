import 'package:elara/features/student/domain/entities/student_group_entity.dart';

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
    return StudentGroupModel(
      id: json['id'] as String,
      name: json['name'] as String,
      subject: json['subject'] as String,
      grade: json['grade'] as String,
      teacherName: json['teacher_name'] as String,
      studentCount: json['student_count'] as int,
      totalLessons: json['total_lessons'] as int,
      completedLessons: json['completed_lessons'] as int,
      progressPercent: (json['progress_percent'] as num).toDouble(),
      colorKey: json['color_key'] as String? ?? 'blue',
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
