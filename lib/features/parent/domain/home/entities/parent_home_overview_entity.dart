import 'package:elara/features/parent/domain/home/entities/parent_activity_entity.dart';
import 'package:elara/features/parent/domain/home/entities/parent_aggregate_stats_entity.dart';
import 'package:elara/features/parent/domain/home/entities/parent_child_progress_entity.dart';
import 'package:equatable/equatable.dart';

/// Full payload for the parent home dashboard (Figma "Home").
class ParentHomeOverviewEntity extends Equatable {
  const ParentHomeOverviewEntity({
    required this.children,
    required this.stats,
    required this.recentActivity,
  });

  final List<ParentChildProgressEntity> children;
  final ParentAggregateStatsEntity stats;
  final List<ParentActivityEntity> recentActivity;

  @override
  List<Object?> get props => [children, stats, recentActivity];
}
