import 'package:elara/features/teacher/domain/group/entities/teacher_student_insight_entity.dart';
import 'package:intl/intl.dart';

class ParentChildInsightModel extends TeacherStudentInsightEntity {
  const ParentChildInsightModel({
    required super.updatedLabel,
    required super.paragraph1,
    required super.paragraph2,
    super.isDraft = false,
  });

  factory ParentChildInsightModel.fromJson(Map<String, dynamic> json) {
    final analyzedAtStr = json['analyzedAt'] as String? ?? '';
    String dateLabel = 'Recently analyzed';
    if (analyzedAtStr.isNotEmpty) {
      try {
        final dt = DateTime.parse(analyzedAtStr).toLocal();
        dateLabel = 'Analyzed • ${DateFormat.yMMMd().add_jm().format(dt)}';
      } catch (_) {
        dateLabel = analyzedAtStr;
      }
    }
    return ParentChildInsightModel(
      updatedLabel: dateLabel,
      paragraph1: json['title'] as String? ?? '',
      paragraph2: json['reportText'] as String? ?? '',
      isDraft: false,
    );
  }
}
