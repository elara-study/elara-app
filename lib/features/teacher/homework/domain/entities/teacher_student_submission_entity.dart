import 'package:elara/features/teacher/homework/domain/entities/teacher_student_answer_entity.dart';
import 'package:equatable/equatable.dart';

/// A single student's submission for a module homework assignment.
class TeacherStudentSubmissionEntity extends Equatable {
  final String id;
  final String studentName;
  final String? avatarUrl;

  /// Number of problems the student submitted answers for.
  final int submittedCount;

  /// Total problems in the assignment.
  final int totalProblems;

  final List<TeacherStudentAnswerEntity> answers;

  const TeacherStudentSubmissionEntity({
    required this.id,
    required this.studentName,
    this.avatarUrl,
    required this.submittedCount,
    required this.totalProblems,
    required this.answers,
  });

  @override
  List<Object?> get props => [
    id,
    studentName,
    avatarUrl,
    submittedCount,
    totalProblems,
    answers,
  ];
}
