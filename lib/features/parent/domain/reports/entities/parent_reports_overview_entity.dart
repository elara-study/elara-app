import 'package:elara/features/parent/domain/reports/entities/parent_insight_entity.dart';
import 'package:equatable/equatable.dart';

/// Parent Reports tab payload (Figma frame Reports, 1467:10103).
class ParentReportsOverviewEntity extends Equatable {
  const ParentReportsOverviewEntity({required this.insights});

  final List<ParentInsightEntity> insights;

  @override
  List<Object?> get props => [insights];
}
