import 'package:elara/features/student/domain/homework/entities/homework_problem_status.dart';
import 'package:elara/features/student/domain/homework/usecases/get_homework_use_case.dart';
import 'package:elara/features/student/domain/homework/usecases/submit_homework_answer_use_case.dart';
import 'package:elara/features/student/presentation/homework/cubits/homework_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Manages the full lifecycle of a homework assignment screen.
///
/// Answer text is stored **inside the state** (not in TextEditingControllers)
/// so we avoid StatefulWidget and keep the UI purely reactive.
///
/// Call [loadHomework] once (triggered from [BlocProvider.create]).
/// Use [updateAnswer] on every keystroke to update draft text in state.
/// Call [submitProblem] when the student taps "Submit Answer".
class HomeworkCubit extends Cubit<HomeworkState> {
  final GetHomeworkUseCase _getHomework;
  final SubmitHomeworkAnswerUseCase _submitHomeworkAnswer;

  String? _groupId;
  String? _moduleId;

  HomeworkCubit(
    this._getHomework,
    this._submitHomeworkAnswer,
  ) : super(const HomeworkInitial());

  /// Fetches the homework assignment. Safe to call again as a manual refresh.
  Future<void> loadHomework({
    required String homeworkId,
    String? groupId,
    String? moduleId,
  }) async {
    _groupId = groupId;
    _moduleId = moduleId;
    emit(const HomeworkLoading());
    try {
      final homework = await _getHomework(
        homeworkId: homeworkId,
        groupId: groupId,
        moduleId: moduleId,
      );
      emit(HomeworkLoaded(homework));
    } catch (e) {
      emit(HomeworkError(e.toString()));
    }
  }

  /// Updates the draft answer text for a problem — called on every keystroke.
  /// No-op if data is not yet loaded.
  void updateAnswer({required String problemId, required String text}) {
    final current = state;
    if (current is HomeworkLoaded) {
      emit(current.withAnswer(problemId: problemId, answerText: text));
    }
  }

  /// Submits the current answer for [problemId], transitioning its status to
  /// [HomeworkProblemStatus.pending]. No-op if data is not yet loaded.
  Future<void> submitProblem(String problemId) async {
    final current = state;
    if (current is HomeworkLoaded) {
      final problem = current.homework.problems.firstWhere((p) => p.id == problemId);
      final answerText = problem.answerText;
      if (answerText.trim().isEmpty) return;

      // Optimistically update state to pending/submitted
      emit(current.withSubmittedProblem(problemId));

      try {
        await _submitHomeworkAnswer(
          moduleId: _moduleId ?? '',
          problemId: problemId,
          groupId: _groupId ?? '',
          answer: answerText,
        );
      } catch (e) {
        // Revert status to active if failed
        final updatedCurrent = state;
        if (updatedCurrent is HomeworkLoaded) {
          final reverted = problem.copyWith(
            status: HomeworkProblemStatus.active,
            submittedAnswer: null,
          );
          emit(HomeworkLoaded(
            updatedCurrent.homework.withUpdatedProblem(reverted),
          ));
        }
      }
    }
  }
}
