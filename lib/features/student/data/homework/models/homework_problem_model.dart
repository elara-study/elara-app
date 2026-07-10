import 'package:elara/features/student/domain/homework/entities/homework_problem_entity.dart';
import 'package:elara/features/student/domain/homework/entities/homework_problem_status.dart';

/// Data model for a single homework problem.
///
/// Extends [HomeworkProblemEntity] so the repository can return it directly
/// without an explicit mapping step.
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

  factory HomeworkProblemModel.fromApiJson(Map<String, dynamic> json) {
    final problemId = json['problemId'] as int;
    return HomeworkProblemModel(
      id: problemId.toString(),
      problemNumber: problemId,
      questionText: json['description'] as String? ?? '',
      status: HomeworkProblemStatus.active,
    );
  }
}
