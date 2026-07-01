import 'package:elara/features/teacher/domain/homework/entities/teacher_homework_problem_entity.dart';
import 'package:elara/features/teacher/domain/homework/entities/teacher_rated_student_entity.dart';
import 'package:elara/features/teacher/domain/homework/entities/teacher_student_submission_entity.dart';
import 'package:equatable/equatable.dart';

/// The homework assignment for a specific module, as seen by the teacher.
class TeacherHomeworkEntity extends Equatable {
  final String moduleId;
  final String moduleTitle;
  final String moduleLabel;
  final String groupId;
  final String subject;

  /// Maximum XP reward shown in the Assignment Overview card.
  final int totalXp;

  final List<TeacherHomeworkProblemEntity> problems;

  /// Students who have submitted at least one answer.
  final List<TeacherStudentSubmissionEntity> submissions;

  /// Students whose submissions have been graded.
  final List<TeacherRatedStudentEntity> ratedStudents;

  const TeacherHomeworkEntity({
    required this.moduleId,
    required this.moduleTitle,
    required this.moduleLabel,
    required this.groupId,
    required this.subject,
    required this.totalXp,
    required this.problems,
    required this.submissions,
    required this.ratedStudents,
  });

  @override
  List<Object?> get props => [
    moduleId,
    moduleTitle,
    moduleLabel,
    groupId,
    subject,
    totalXp,
    problems,
    submissions,
    ratedStudents,
  ];
}
