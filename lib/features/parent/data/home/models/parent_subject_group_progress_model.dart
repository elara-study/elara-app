import 'package:elara/features/parent/domain/home/entities/parent_subject_group_progress_entity.dart';

/// DTO for a subject row on the Child Card.
class ParentSubjectGroupProgressModel {
  const ParentSubjectGroupProgressModel({
    required this.name,
    required this.progress,
  });

  final String name;
  final double progress;

  factory ParentSubjectGroupProgressModel.fromJson(Map<String, dynamic> json) {
    final rawProgress = json['progress'] ?? json['progress_percentage'] as num? ?? 0.0;
    final double progressVal;
    if (json.containsKey('progress_percentage')) {
      progressVal = (rawProgress as num).toDouble() / 100.0;
    } else {
      progressVal = (rawProgress as num).toDouble();
    }
    return ParentSubjectGroupProgressModel(
      name: json['name'] as String? ?? json['subject'] as String? ?? '',
      progress: progressVal,
    );
  }

  ParentSubjectGroupProgressEntity toEntity() =>
      ParentSubjectGroupProgressEntity(name: name, progress: progress);
}
