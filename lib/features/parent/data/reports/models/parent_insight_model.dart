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

  factory ParentInsightModel.fromJson(Map<String, dynamic> json) {
    return ParentInsightModel(
      id: json['id'] as String? ?? '',
      childName: json['childName'] as String? ?? '',
      dateLabel: json['dateLabel'] as String? ?? '',
      reportParagraph1: json['reportParagraph1'] as String? ?? '',
      reportParagraph2: json['reportParagraph2'] as String? ?? '',
    );
  }

  ParentInsightEntity toEntity() => ParentInsightEntity(
    id: id,
    childName: childName,
    dateLabel: dateLabel,
    reportParagraph1: reportParagraph1,
    reportParagraph2: reportParagraph2,
  );
}
