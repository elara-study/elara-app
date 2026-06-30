import 'package:elara/features/teacher/group/domain/entities/teacher_roadmap_entity.dart';

class TeacherRoadmapModel extends TeacherRoadmapEntity {
  const TeacherRoadmapModel({
    required super.id,
    required super.name,
    required super.lessonsCount,
    required super.materials,
  });

  factory TeacherRoadmapModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? json;
    
    // Support both OpenAPI format (nested roadmap/materials) and actual backend format
    final roadmapObj = data['roadmap'] as Map<String, dynamic>? ?? data;
    
    final materialsArr = data['materials'] as List<dynamic>? 
        ?? data['modules'] as List<dynamic>? 
        ?? roadmapObj['materials'] as List<dynamic>? 
        ?? roadmapObj['modules'] as List<dynamic>? 
        ?? [];

    return TeacherRoadmapModel(
      id: roadmapObj['id']?.toString() ?? '',
      name: roadmapObj['name']?.toString() ?? '',
      lessonsCount: roadmapObj['lessonsCount'] as int? ?? materialsArr.length,
      materials: materialsArr.asMap().entries.map((entry) {
        final index = entry.key;
        final mObj = entry.value as Map<String, dynamic>;
        return TeacherRoadmapMaterial(
          title: mObj['title']?.toString() ?? '',
          type: mObj['type']?.toString() ?? 'Module ${index + 1}',
          url: mObj['url']?.toString() ?? mObj['description']?.toString() ?? '',
        );
      }).toList(),
    );
  }
}
