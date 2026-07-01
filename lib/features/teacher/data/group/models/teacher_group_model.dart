import 'package:elara/features/teacher/domain/group/entities/teacher_group_entity.dart';

class TeacherGroupModel extends TeacherGroupEntity {
  const TeacherGroupModel({
    super.id,
    required super.name,
    required super.grade,
    required super.subject,
    super.roadmapName,
    super.studentCount,
    super.totalLessons,
    super.progressPercent,
    super.colorKey,
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
      roadmapName: json['roadmapName'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'grade':
          int.tryParse(grade) ?? 0, // Convert back to int for the request body
      'subject': subject,
      if (roadmapName != null) 'roadmap': roadmapName,
    };
  }

  TeacherGroupEntity toEntity() {
    return TeacherGroupEntity(
      id: id,
      name: name,
      grade: grade,
      subject: subject,
      roadmapName: roadmapName,
      studentCount: studentCount,
      totalLessons: totalLessons,
      progressPercent: progressPercent,
      colorKey: colorKey,
    );
  }
}
