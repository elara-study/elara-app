import 'package:elara/features/teacher/domain/group/entities/teacher_group_entity.dart';

class TeacherGroupModel extends TeacherGroupEntity {
  const TeacherGroupModel({
    required super.id,
    required super.name,
    required super.grade,
    required super.subject,
    required super.studentCount,
    required super.totalLessons,
    required super.progressPercent,
    required super.colorKey,
  });

  factory TeacherGroupModel.fromJson(Map<String, dynamic> json) {
    return TeacherGroupModel(
      id:
          json['id'] as String? ??
          '', // API might not return it yet based on swagger
      name: json['name'] as String,
      grade:
          json['grade']?.toString() ??
          '0', // Swagger says int, GroupEntity expects String
      subject: json['subject'] as String,
      studentCount: json['studentCount'] as int? ?? 0,
      totalLessons: json['totalLessons'] as int? ?? 0,
      progressPercent: json['progressPercent'] as double? ?? 0.0,
      colorKey: json['colorKey'] as String? ?? 'blue',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'grade':
          int.tryParse(grade) ?? 0, // Convert back to int for the request body
      'subject': subject,
    };
  }

  TeacherGroupEntity toEntity() {
    return TeacherGroupEntity(
      id: id,
      name: name,
      grade: grade,
      subject: subject,
      studentCount: studentCount,
      totalLessons: totalLessons,
      progressPercent: progressPercent,
      colorKey: colorKey,
    );
  }
}
