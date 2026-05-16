import 'package:elara/features/parent/data/reports/models/parent_insight_model.dart';
import 'package:elara/features/parent/domain/reports/entities/parent_reports_overview_entity.dart';

/// DTO for parent Reports tab payload.
class ParentReportsOverviewModel {
  const ParentReportsOverviewModel({required this.insights});

  final List<ParentInsightModel> insights;

  ParentReportsOverviewEntity toEntity() => ParentReportsOverviewEntity(
    insights: insights.map((e) => e.toEntity()).toList(),
  );
}
