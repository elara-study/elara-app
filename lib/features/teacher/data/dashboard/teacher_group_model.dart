import 'package:elara/features/teacher/domain/group/entities/teacher_group_entity.dart';

class TeacherGroupModel extends TeacherGroupEntity {
  TeacherGroupModel({
    required super.id,
    required super.name,
    required super.subject,
    required super.grade,
    required super.studentCount,
    required super.totalLessons,
    required super.progressPercent,
    required super.colorKey,
  });

  factory TeacherGroupModel.fromJson(Map<String, dynamic> json) {
    return TeacherGroupModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      subject: json['subject'] as String? ?? '',
      grade: json['grade']?.toString() ?? '0',
      studentCount: json['studentsCount'] as int? ?? 0,
      totalLessons: json['totalLessons'] as int? ?? 0,
      progressPercent: (json['progressPercent'] as num?)?.toDouble() ?? 0.0,
      colorKey: json['colorKey'] as String? ?? 'blue',
    );
  }
}
