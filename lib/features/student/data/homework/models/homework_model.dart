import 'package:elara/features/student/data/homework/models/homework_problem_model.dart';
import 'package:elara/features/student/domain/homework/entities/homework_entity.dart';

/// Data model for the full homework assignment.
///
/// Extends [HomeworkEntity] — no explicit entity-to-model mapping needed.
class HomeworkModel extends HomeworkEntity {
  const HomeworkModel({
    required super.id,
    required super.subject,
    required super.moduleTitle,
    required super.totalXp,
    required super.problems,
  });

  factory HomeworkModel.fromApiJson(Map<String, dynamic> json, String moduleId) {
    final data = json['data'] as Map<String, dynamic>? ?? {};
    final problemsList = data['problems'] as List<dynamic>? ?? [];
    return HomeworkModel(
      id: moduleId,
      subject: '',
      moduleTitle: data['moduleName'] as String? ?? '',
      totalXp: data['totalScoreXp'] as int? ?? 100,
      problems: problemsList
          .map((p) => HomeworkProblemModel.fromApiJson(p as Map<String, dynamic>))
          .toList(),
    );
  }
}
