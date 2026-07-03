import 'package:elara/features/teacher/domain/group/entities/teacher_student_insight_entity.dart';

class ParentChildInsightModel extends TeacherStudentInsightEntity {
  const ParentChildInsightModel({
    required super.updatedLabel,
    required super.paragraph1,
    required super.paragraph2,
    super.isDraft = false,
  });

  factory ParentChildInsightModel.fromJson(Map<String, dynamic> json) {
    return ParentChildInsightModel(
      updatedLabel: json['updated_at'] as String? ?? json['updatedLabel'] as String? ?? '',
      paragraph1: json['paragraph1'] as String? ?? '',
      paragraph2: json['paragraph2'] as String? ?? '',
      isDraft: json['is_draft'] as bool? ?? json['isDraft'] as bool? ?? false,
    );
  }
}
