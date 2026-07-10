import 'package:elara/features/parent/domain/home/entities/parent_aggregate_stats_entity.dart';

/// DTO for aggregate stats on parent home.
class ParentAggregateStatsModel {
  const ParentAggregateStatsModel({
    required this.avgCompletionPercent,
    required this.avgAttendancePercent,
  });

  final int avgCompletionPercent;
  final int avgAttendancePercent;

  factory ParentAggregateStatsModel.fromJson(Map<String, dynamic> json) {
    return ParentAggregateStatsModel(
      avgCompletionPercent: (json['avg_completion'] ?? json['avgCompletionPercent'] ?? 0) as int,
      avgAttendancePercent: (json['avg_attendance'] ?? json['avgAttendancePercent'] ?? 0) as int,
    );
  }

  ParentAggregateStatsEntity toEntity() => ParentAggregateStatsEntity(
    avgCompletionPercent: avgCompletionPercent,
    avgAttendancePercent: avgAttendancePercent,
  );
}
