import 'package:elara/features/parent/data/children/models/parent_child_insight_model.dart';
import 'package:elara/features/parent/data/home/models/parent_child_progress_model.dart';
import 'package:elara/features/parent/domain/children/entities/parent_child_profile_entity.dart';
import 'package:elara/features/parent/domain/children/entities/parent_homework_card_entity.dart';

class ParentChildProfileModel extends ParentChildProfileEntity {
  const ParentChildProfileModel({
    required super.child,
    required super.attendanceLabel,
    super.insight,
    required super.homeworks,
  });

  factory ParentChildProfileModel.fromJson(Map<String, dynamic> json) {
    final childData = json['child'] as Map<String, dynamic>? ?? {};
    final insightData = json['latest_insight'] as Map<String, dynamic>? ?? json['insight'] as Map<String, dynamic>?;
    final homeworksList = json['recent_homeworks'] as List? ?? json['homeworks'] as List? ?? [];

    return ParentChildProfileModel(
      child: ParentChildProgressModel.fromJson(childData).toEntity(),
      attendanceLabel: json['attendance_percentage'] as String? ?? json['attendanceLabel'] as String? ?? '100%',
      insight: insightData != null ? ParentChildInsightModel.fromJson(insightData) : null,
      homeworks: homeworksList
          .whereType<Map<String, dynamic>>()
          .map(ParentHomeworkCardEntity.fromJson)
          .toList(),
    );
  }
}
