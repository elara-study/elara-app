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

  factory ParentHomeOverviewModel.fromJson(Map<String, dynamic> json) {
    final childrenList = json['children'] as List? ?? [];
    final statsMap = json['overall_stats'] as Map<String, dynamic>? ?? json['stats'] as Map<String, dynamic>? ?? {};
    final recentList = json['recent_activity'] as List? ?? json['recentActivity'] as List? ?? [];

    return ParentHomeOverviewModel(
      children: childrenList
          .whereType<Map<String, dynamic>>()
          .map(ParentChildProgressModel.fromJson)
          .toList(),
      stats: ParentAggregateStatsModel.fromJson(statsMap),
      recentActivity: recentList
          .whereType<Map<String, dynamic>>()
          .map(ParentActivityModel.fromJson)
          .toList(),
    );
  }

  ParentHomeOverviewEntity toEntity() => ParentHomeOverviewEntity(
    children: children.map((e) => e.toEntity()).toList(),
    stats: stats.toEntity(),
    recentActivity: recentActivity.map((e) => e.toEntity()).toList(),
  );
}
