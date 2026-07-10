import 'package:elara/features/student/domain/homework/entities/homework_problem_entity.dart';
import 'package:elara/features/student/domain/homework/entities/homework_problem_status.dart';

class ParentHomeworkProblemModel extends HomeworkProblemEntity {
  const ParentHomeworkProblemModel({
    required super.id,
    required super.problemNumber,
    required super.questionText,
    required super.status,
    super.answerText = '',
    super.submittedAnswer,
    super.grade,
    super.maxGrade,
    super.feedback,
  });

  factory ParentHomeworkProblemModel.fromJson(Map<String, dynamic> json) {
    final statusStr = json['status'] as String? ?? 'active';
    final status = HomeworkProblemStatus.values.firstWhere(
      (e) => e.name == statusStr.toLowerCase(),
      orElse: () => HomeworkProblemStatus.active,
    );

    return ParentHomeworkProblemModel(
      id: (json['id'] ?? '').toString(),
      problemNumber: json['problem_number'] as int? ?? json['problemNumber'] as int? ?? 1,
      questionText: json['question_text'] as String? ?? json['description'] as String? ?? '',
      status: status,
      answerText: json['answer_text'] as String? ?? '',
      submittedAnswer: json['submitted_answer'] as String?,
      grade: json['grade'] as int?,
      maxGrade: json['max_grade'] as int? ?? json['maxGrade'] as int?,
      feedback: json['feedback'] as String?,
    );
  }
}
