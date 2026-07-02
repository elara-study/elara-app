import 'package:equatable/equatable.dart';

/// Answer detail from the per-student submissions API.
class TeacherStudentAnswerDetailEntity extends Equatable {
  final int problemId;
  final String problemText;
  final String? studentTextAnswer;
  final String? studentImageUrl;

  const TeacherStudentAnswerDetailEntity({
    required this.problemId,
    required this.problemText,
    this.studentTextAnswer,
    this.studentImageUrl,
  });

  @override
  List<Object?> get props => [
    problemId,
    problemText,
    studentTextAnswer,
    studentImageUrl,
  ];
}

/// Full submission detail for a single student, returned by
/// GET /api/v1/teacher/modules/{moduleId}/homework/submissions/{studentId}
class TeacherStudentSubmissionDetailEntity extends Equatable {
  final String studentName;
  final List<TeacherStudentAnswerDetailEntity> answers;

  const TeacherStudentSubmissionDetailEntity({
    required this.studentName,
    required this.answers,
  });

  @override
  List<Object?> get props => [studentName, answers];
}
