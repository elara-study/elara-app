import 'package:elara/features/student/homework/domain/entities/homework_entity.dart';
import 'package:elara/features/student/homework/domain/entities/homework_problem_status.dart';
import 'package:equatable/equatable.dart';

abstract class HomeworkState extends Equatable {
  const HomeworkState();

  @override
  List<Object?> get props => [];
}

class HomeworkInitial extends HomeworkState {
  const HomeworkInitial();
}

class HomeworkLoading extends HomeworkState {
  const HomeworkLoading();
}

class HomeworkLoaded extends HomeworkState {
  final HomeworkEntity homework;

  const HomeworkLoaded(this.homework);

  /// Returns a copy with one problem's [answerText] updated.
  HomeworkLoaded withAnswer({
    required String problemId,
    required String answerText,
  }) {
    final updated = homework.problems.map((p) {
      return p.id == problemId ? p.copyWith(answerText: answerText) : p;
    }).toList();

    return HomeworkLoaded(
      HomeworkEntity(
        id: homework.id,
        subject: homework.subject,
        moduleTitle: homework.moduleTitle,
        totalXp: homework.totalXp,
        problems: updated,
      ),
    );
  }

  /// Returns a copy with one problem submitted (status → pending).
  HomeworkLoaded withSubmittedProblem(String problemId) {
    final problem = homework.problems.firstWhere((p) => p.id == problemId);
    final updated = problem.copyWith(
      status: HomeworkProblemStatus.pending,
      submittedAnswer: problem.answerText,
    );
    return HomeworkLoaded(homework.withUpdatedProblem(updated));
  }

  @override
  List<Object?> get props => [homework];
}

class HomeworkError extends HomeworkState {
  final String message;

  const HomeworkError(this.message);

  @override
  List<Object?> get props => [message];
}
