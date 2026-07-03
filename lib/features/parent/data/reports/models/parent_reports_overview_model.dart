import 'package:elara/features/parent/data/reports/models/parent_insight_model.dart';
import 'package:elara/features/parent/domain/reports/entities/parent_reports_overview_entity.dart';
import 'package:intl/intl.dart';

/// DTO for parent Reports tab payload.
class ParentReportsOverviewModel {
  const ParentReportsOverviewModel({required this.insights});

  final List<ParentInsightModel> insights;

  factory ParentReportsOverviewModel.fromJson(dynamic json) {
    final List<ParentInsightModel> list = [];
    if (json is List) {
      for (final childObj in json) {
        if (childObj is Map<String, dynamic>) {
          final childName = childObj['childName'] as String? ?? '';
          final reportsList = childObj['reports'] as List? ?? [];
          for (final report in reportsList) {
            if (report is Map<String, dynamic>) {
              final analyzedAtStr = report['analyzedAt'] as String? ?? '';
              String dateLabel = 'Recently analyzed';
              if (analyzedAtStr.isNotEmpty) {
                try {
                  final dt = DateTime.parse(analyzedAtStr).toLocal();
                  dateLabel = 'Analyzed • ${DateFormat.yMMMd().add_jm().format(dt)}';
                } catch (_) {
                  dateLabel = analyzedAtStr;
                }
              }
              list.add(
                ParentInsightModel(
                  id: report['reportId'] as String? ?? '',
                  childName: childName,
                  dateLabel: dateLabel,
                  reportParagraph1: report['title'] as String? ?? '',
                  reportParagraph2: report['reportText'] as String? ?? '',
                ),
              );
            }
          }
        }
      }
    }
    return ParentReportsOverviewModel(insights: list);
  }

  ParentReportsOverviewEntity toEntity() => ParentReportsOverviewEntity(
    insights: insights.map((e) => e.toEntity()).toList(),
  );
}
