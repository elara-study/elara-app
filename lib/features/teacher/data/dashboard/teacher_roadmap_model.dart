import 'package:elara/features/teacher/domain/group/entities/teacher_roadmap_entity.dart';

class TeacherRoadmapModuleModel extends TeacherRoadmapModuleEntity {
  const TeacherRoadmapModuleModel({
    required super.id,
    required super.title,
    required super.description,
  });

  factory TeacherRoadmapModuleModel.fromJson(Map<String, dynamic> json) {
    return TeacherRoadmapModuleModel(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'title': title, 'description': description};
  }
}

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
    return TeacherRoadmapModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      grade: (json['grade'] as num?)?.toInt() ?? 1,
      subject: json['subject']?.toString() ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
      modules:
          (json['modules'] as List<dynamic>?)
              ?.map(
                (e) => TeacherRoadmapModuleModel.fromJson(
                  e as Map<String, dynamic>,
                ),
              )
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'grade': grade,
      'subject': subject,
      'createdAt': createdAt.toIso8601String(),
      'modules': (modules as List<TeacherRoadmapModuleModel>)
          .map((e) => e.toJson())
          .toList(),
    };
  }

  TeacherRoadmapEntity toEntity() {
    return this;
  }
}
