import 'package:equatable/equatable.dart';

class TeacherRoadmapEntity extends Equatable {
  final String id;
  final String name;
  final int lessonsCount;
  final List<TeacherRoadmapMaterial> materials;

  const TeacherRoadmapEntity({
    required this.id,
    required this.name,
    required this.lessonsCount,
    required this.materials,
  });

  @override
  List<Object?> get props => [id, name, lessonsCount, materials];
}

class TeacherRoadmapMaterial extends Equatable {
  final String title;
  final String type;
  final String url;

  const TeacherRoadmapMaterial({
    required this.title,
    required this.type,
    required this.url,
  });

  @override
  List<Object?> get props => [title, type, url];
}
