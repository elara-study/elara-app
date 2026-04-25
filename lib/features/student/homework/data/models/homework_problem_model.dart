import 'package:elara/features/student/homework/domain/entities/homework_problem_entity.dart';

/// Data model for a single homework problem.
///
/// Extends [HomeworkProblemEntity] so the repository can return it directly
/// without an explicit mapping step. Add [fromJson] when the backend is ready.
class HomeworkProblemModel extends HomeworkProblemEntity {
  const HomeworkProblemModel({
    required super.id,
    required super.problemNumber,
    required super.questionText,
    required super.status,
    super.answerText,
    super.submittedAnswer,
    super.grade,
    super.maxGrade,
    super.feedback,
  });

  // ── REAL ──────────────────────────────────────────────────────────────────
  // factory HomeworkProblemModel.fromJson(Map<String, dynamic> json) {
  //   return HomeworkProblemModel(
  //     id: json['id'] as String,
  //     problemNumber: json['problem_number'] as int,
  //     questionText: json['question'] as String,
  //     status: HomeworkProblemStatus.values.byName(json['status'] as String),
  //     submittedAnswer: json['submitted_answer'] as String?,
  //     grade: json['grade'] as int?,
  //     maxGrade: json['max_grade'] as int?,
  //     feedback: json['feedback'] as String?,
  //   );
  // }
}
