import 'package:elara/features/parent/domain/reports/entities/parent_insight_entity.dart';

/// DTO for a report insight card.
class ParentInsightModel {
  const ParentInsightModel({
    required this.id,
    required this.childName,
    required this.dateLabel,
    required this.reportParagraph1,
    required this.reportParagraph2,
  });

  final String id;
  final String childName;
  final String dateLabel;
  final String reportParagraph1;
  final String reportParagraph2;

  ParentInsightEntity toEntity() => ParentInsightEntity(
    id: id,
    childName: childName,
    dateLabel: dateLabel,
    reportParagraph1: reportParagraph1,
    reportParagraph2: reportParagraph2,
  );
}
