import 'package:elara/features/teacher/group/domain/entities/teacher_roadmap_entity.dart';

class TeacherRoadmapModel extends TeacherRoadmapEntity {
  const TeacherRoadmapModel({
    required super.id,
    required super.name,
    required super.lessonsCount,
    required super.materials,
  });

  factory TeacherRoadmapModel.fromJson(Map<String, dynamic> json) {
    final roadmapObj = json['roadmap'] as Map<String, dynamic>? ?? {};
    final materialsArr = json['materials'] as List<dynamic>? ?? [];

    return TeacherRoadmapModel(
      id: roadmapObj['id']?.toString() ?? '',
      name: roadmapObj['name']?.toString() ?? '',
      lessonsCount: roadmapObj['lessonsCount'] as int? ?? 0,
      materials: materialsArr.map((m) {
        final mObj = m as Map<String, dynamic>;
        return TeacherRoadmapMaterial(
          title: mObj['title']?.toString() ?? '',
          type: mObj['type']?.toString() ?? '',
          url: mObj['url']?.toString() ?? '',
        );
      }).toList(),
    );
  }
}
