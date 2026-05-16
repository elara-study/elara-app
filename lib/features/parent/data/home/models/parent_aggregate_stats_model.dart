import 'package:elara/features/parent/domain/home/entities/parent_aggregate_stats_entity.dart';

/// DTO for aggregate stats on parent home.
class ParentAggregateStatsModel {
  const ParentAggregateStatsModel({
    required this.avgCompletionPercent,
    required this.avgAttendancePercent,
  });

  final int avgCompletionPercent;
  final int avgAttendancePercent;

  ParentAggregateStatsEntity toEntity() => ParentAggregateStatsEntity(
    avgCompletionPercent: avgCompletionPercent,
    avgAttendancePercent: avgAttendancePercent,
  );
}
