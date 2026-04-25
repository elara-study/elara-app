import 'package:elara/features/student/homework/domain/entities/homework_entity.dart';

/// Data model for the full homework assignment.
///
/// Extends [HomeworkEntity] — no explicit entity-to-model mapping needed.
/// Add [fromJson] when the backend is ready.
class HomeworkModel extends HomeworkEntity {
  const HomeworkModel({
    required super.id,
    required super.subject,
    required super.moduleTitle,
    required super.totalXp,
    required super.problems,
  });

  // ── REAL ──────────────────────────────────────────────────────────────────
  // factory HomeworkModel.fromJson(Map<String, dynamic> json) {
  //   return HomeworkModel(
  //     id: json['id'] as String,
  //     subject: json['subject'] as String,
  //     moduleTitle: json['module_title'] as String,
  //     totalXp: json['total_xp'] as int,
  //     problems: (json['problems'] as List)
  //         .map((p) => HomeworkProblemModel.fromJson(p as Map<String, dynamic>))
  //         .toList(),
  //   );
  // }
}
