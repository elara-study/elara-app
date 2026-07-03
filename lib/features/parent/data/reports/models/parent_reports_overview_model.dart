import 'package:elara/features/parent/data/reports/models/parent_insight_model.dart';
import 'package:elara/features/parent/domain/reports/entities/parent_reports_overview_entity.dart';

/// DTO for parent Reports tab payload.
class ParentReportsOverviewModel {
  const ParentReportsOverviewModel({required this.insights});

  final List<ParentInsightModel> insights;

  factory ParentReportsOverviewModel.fromJson(dynamic json) {
    if (json is List) {
      return ParentReportsOverviewModel(
        insights: json
            .map((e) => ParentInsightModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
    } else if (json is Map<String, dynamic>) {
      final list = json['insights'] as List? ?? [];
      return ParentReportsOverviewModel(
        insights: list
            .map((e) => ParentInsightModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
    }
    return const ParentReportsOverviewModel(insights: []);
  }

  ParentReportsOverviewEntity toEntity() => ParentReportsOverviewEntity(
    insights: insights.map((e) => e.toEntity()).toList(),
  );
}
