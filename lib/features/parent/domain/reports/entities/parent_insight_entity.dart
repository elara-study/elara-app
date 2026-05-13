import 'package:equatable/equatable.dart';

/// Teacher insight / report card (Figma Insight, node 1417:7620).
class ParentInsightEntity extends Equatable {
  const ParentInsightEntity({
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

  @override
  List<Object?> get props => [
    id,
    childName,
    dateLabel,
    reportParagraph1,
    reportParagraph2,
  ];
}
