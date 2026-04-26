import 'package:elara/features/student/homework/domain/usecases/get_homework_use_case.dart';
import 'package:elara/features/student/homework/presentation/cubits/homework_state.dart';
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

  HomeworkCubit(this._getHomework) : super(const HomeworkInitial());

  /// Fetches the homework assignment. Safe to call again as a manual refresh.
  Future<void> loadHomework({
    required String homeworkId,
    String? groupId,
    String? moduleId,
  }) async {
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
  ///
  /// When the backend is ready, replace the local-only state update below
  /// with a use case that POSTs to the server, then emits the result.
  void submitProblem(String problemId) {
    final current = state;
    if (current is HomeworkLoaded) {
      emit(current.withSubmittedProblem(problemId));
      // TODO: call SubmitHomeworkAnswerUseCase(problemId, answer) when backend ready.
    }
  }
}
