import 'package:elara/features/parent/data/home/models/parent_activity_model.dart';
import 'package:elara/features/parent/data/home/models/parent_aggregate_stats_model.dart';
import 'package:elara/features/parent/data/home/models/parent_child_progress_model.dart';
import 'package:elara/features/parent/domain/home/entities/parent_home_overview_entity.dart';

/// DTO for the parent home dashboard payload.
class ParentHomeOverviewModel {
  const ParentHomeOverviewModel({
    required this.children,
    required this.stats,
    required this.recentActivity,
  });

  final List<ParentChildProgressModel> children;
  final ParentAggregateStatsModel stats;
  final List<ParentActivityModel> recentActivity;

  ParentHomeOverviewEntity toEntity() => ParentHomeOverviewEntity(
    children: children.map((e) => e.toEntity()).toList(),
    stats: stats.toEntity(),
    recentActivity: recentActivity.map((e) => e.toEntity()).toList(),
  );
}
