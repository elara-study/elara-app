import 'package:elara/features/parent/domain/home/entities/parent_activity_entity.dart';

/// DTO for a parent home activity row.
class ParentActivityModel {
  const ParentActivityModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.timeLabel,
  });

  final String id;
  final String title;
  final String subtitle;
  final String timeLabel;

  factory ParentActivityModel.fromJson(Map<String, dynamic> json) {
    return ParentActivityModel(
      id: (json['id'] ?? '').toString(),
      title: json['title'] as String? ?? '',
      subtitle: json['description'] as String? ?? json['subtitle'] as String? ?? '',
      timeLabel: json['time_ago'] as String? ?? json['timeLabel'] as String? ?? '',
    );
  }

  ParentActivityEntity toEntity() => ParentActivityEntity(
    id: id,
    title: title,
    subtitle: subtitle,
    timeLabel: timeLabel,
  );
}
