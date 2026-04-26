import 'package:elara/features/student/homework/domain/entities/homework_problem_status.dart';
import 'package:equatable/equatable.dart';

/// A single problem within a homework assignment.
///
/// [problemNumber] is the 1-based display index shown in the UI badge.
/// [answerText] is non-null when the student has typed (but not yet submitted) an answer.
/// [submittedAnswer] is non-null once the student has submitted.
/// [grade] and [feedback] are populated only when [status] is [HomeworkProblemStatus.graded].
class HomeworkProblemEntity extends Equatable {
  final String id;
  final int problemNumber;
  final String questionText;
  final HomeworkProblemStatus status;

  /// Draft answer currently in the text field (not yet submitted).
  final String answerText;

  /// The answer that was actually submitted to the teacher.
  final String? submittedAnswer;

  /// Score awarded by the teacher (e.g. 8 out of 10).
  final int? grade;
  final int? maxGrade;

  /// Optional teacher feedback shown after grading.
  final String? feedback;

  const HomeworkProblemEntity({
    required this.id,
    required this.problemNumber,
    required this.questionText,
    required this.status,
    this.answerText = '',
    this.submittedAnswer,
    this.grade,
    this.maxGrade,
    this.feedback,
  });

  HomeworkProblemEntity copyWith({
    String? answerText,
    HomeworkProblemStatus? status,
    String? submittedAnswer,
  }) {
    return HomeworkProblemEntity(
      id: id,
      problemNumber: problemNumber,
      questionText: questionText,
      status: status ?? this.status,
      answerText: answerText ?? this.answerText,
      submittedAnswer: submittedAnswer ?? this.submittedAnswer,
      grade: grade,
      maxGrade: maxGrade,
      feedback: feedback,
    );
  }

  @override
  List<Object?> get props => [
        id,
        problemNumber,
        questionText,
        status,
        answerText,
        submittedAnswer,
        grade,
        maxGrade,
        feedback,
      ];
}
