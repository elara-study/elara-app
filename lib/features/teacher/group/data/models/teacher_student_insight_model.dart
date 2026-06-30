import 'package:elara/features/teacher/group/domain/entities/teacher_student_insight_entity.dart';
import 'package:intl/intl.dart';

class TeacherStudentInsightModel extends TeacherStudentInsightEntity {
  const TeacherStudentInsightModel({
    required super.updatedLabel,
    required super.paragraph1,
    required super.paragraph2,
    super.isDraft = true,
  });

  factory TeacherStudentInsightModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? {};
    final insights = data['insights'] as List<dynamic>? ?? data['reports'] as List<dynamic>? ?? [];

    if (insights.isEmpty) {
      return const TeacherStudentInsightModel(
        updatedLabel: 'No Insights Yet',
        paragraph1: 'No AI insights have been generated for this student yet.',
        paragraph2: '',
        isDraft: false,
      );
    }

    Map<String, dynamic> firstInsight = insights[0] as Map<String, dynamic>;
    for (var i in insights) {
      final map = i as Map<String, dynamic>;
      if (map['source'] == 'ai') {
        firstInsight = map;
        break;
      }
    }

    final reportText = firstInsight['content']?.toString() ?? firstInsight['reportText']?.toString() ?? '';
    final analyzedAtStr = firstInsight['lastUpdated']?.toString() ?? firstInsight['analyzedAt']?.toString() ?? '';

    String updatedLabel = 'Recently analyzed';
    if (analyzedAtStr.isNotEmpty) {
      try {
        final dt = DateTime.parse(analyzedAtStr).toLocal();
        updatedLabel = 'Analyzed • ${DateFormat.yMMMd().add_jm().format(dt)}';
      } catch (_) {}
    }

    final parts = reportText.split('\n\n');
    final p1 = parts.isNotEmpty ? parts[0] : reportText;
    final p2 = parts.length > 1 ? parts.sublist(1).join('\n\n') : '';

    return TeacherStudentInsightModel(
      updatedLabel: updatedLabel,
      paragraph1: p1,
      paragraph2: p2,
      isDraft: false,
    );
  }
}
