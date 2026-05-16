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

  ParentActivityEntity toEntity() => ParentActivityEntity(
    id: id,
    title: title,
    subtitle: subtitle,
    timeLabel: timeLabel,
  );
}
