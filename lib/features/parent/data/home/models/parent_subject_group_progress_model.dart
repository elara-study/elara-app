import 'package:elara/features/parent/domain/home/entities/parent_subject_group_progress_entity.dart';

/// DTO for a subject row on the Child Card.
class ParentSubjectGroupProgressModel {
  const ParentSubjectGroupProgressModel({
    required this.name,
    required this.progress,
  });

  final String name;
  final double progress;

  ParentSubjectGroupProgressEntity toEntity() =>
      ParentSubjectGroupProgressEntity(name: name, progress: progress);
}
