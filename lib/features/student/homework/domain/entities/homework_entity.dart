import 'package:elara/features/student/homework/domain/entities/homework_problem_entity.dart';
import 'package:elara/features/student/homework/domain/entities/homework_problem_status.dart';
import 'package:equatable/equatable.dart';

/// The full homework assignment for a specific module.
///
/// [subject] is the group name (e.g. "Physics 101").
/// [moduleTitle] is the module/lesson name (e.g. "Kinematics").
/// [totalXp] is the maximum XP reward for completing all problems.
class HomeworkEntity extends Equatable {
  final String id;
  final String subject;
  final String moduleTitle;
  final int totalXp;
  final List<HomeworkProblemEntity> problems;

  const HomeworkEntity({
    required this.id,
    required this.subject,
    required this.moduleTitle,
    required this.totalXp,
    required this.problems,
  });

  /// Number of problems the student has submitted or had graded.
  int get completedProblems =>
      problems.where((p) => p.status != HomeworkProblemStatus.active).length;

  int get totalProblems => problems.length;

  /// Progress fraction [0.0 – 1.0] — safe for LinearProgressIndicator.
  double get progressPercent =>
      totalProblems > 0 ? (completedProblems / totalProblems).clamp(0.0, 1.0) : 0.0;

  /// Returns a copy with one problem replaced by [updatedProblem].
  HomeworkEntity withUpdatedProblem(HomeworkProblemEntity updatedProblem) {
    return HomeworkEntity(
      id: id,
      subject: subject,
      moduleTitle: moduleTitle,
      totalXp: totalXp,
      problems: [
        for (final p in problems)
          if (p.id == updatedProblem.id) updatedProblem else p,
      ],
    );
  }

  @override
  List<Object?> get props => [id, subject, moduleTitle, totalXp, problems];
}
