import 'package:elara/features/teacher/domain/group/entities/teacher_roadmap_entity.dart';

class TeacherRoadmapModel extends TeacherRoadmapEntity {
  const TeacherRoadmapModel({
    required super.id,
    required super.name,
    required super.description,
    required super.grade,
    required super.subject,
    required super.createdAt,
    required super.modules,
  });

  factory TeacherRoadmapModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? json;

    // Support both OpenAPI format (nested roadmap/modules) and actual backend
    final roadmapObj = data['roadmap'] as Map<String, dynamic>? ?? data;

    final modulesArr =
        data['modules'] as List<dynamic>? ??
        roadmapObj['modules'] as List<dynamic>? ??
        [];

    return TeacherRoadmapModel(
      id: roadmapObj['id']?.toString() ?? '',
      name: roadmapObj['name']?.toString() ?? '',
      description: roadmapObj['description']?.toString() ?? '',
      grade: int.tryParse(roadmapObj['grade']?.toString() ?? '0') ?? 0,
      subject: roadmapObj['subject']?.toString() ?? '',
      createdAt: _parseDateTime(roadmapObj['createdAt']),
      modules: modulesArr.map((m) {
        final mObj = m as Map<String, dynamic>;
        return TeacherRoadmapModuleEntity(
          id: mObj['id']?.toString() ?? '',
          title: mObj['title']?.toString() ?? '',
          description: mObj['description']?.toString() ?? '',
        );
      }).toList(),
    );
  }

  static DateTime _parseDateTime(dynamic value) {
    if (value == null) return DateTime.now();
    if (value is DateTime) return value;
    if (value is String) {
      try {
        return DateTime.parse(value);
      } catch (_) {
        return DateTime.now();
      }
    }
    return DateTime.now();
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'grade': grade,
      'subject': subject,
      'createdAt': createdAt.toIso8601String(),
      'modules': modules
          .map(
            (m) => {'id': m.id, 'title': m.title, 'description': m.description},
          )
          .toList(),
    };
  }
}
