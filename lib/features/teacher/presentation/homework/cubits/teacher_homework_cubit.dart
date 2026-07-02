import 'package:elara/features/teacher/domain/homework/entities/teacher_homework_entity.dart';
import 'package:elara/features/teacher/domain/homework/entities/teacher_student_submission_detail_entity.dart';
import 'package:elara/features/teacher/domain/homework/usecases/add_teacher_module_problem_usecase.dart';
import 'package:elara/features/teacher/domain/homework/usecases/delete_teacher_problem_usecase.dart';
import 'package:elara/features/teacher/domain/homework/usecases/get_teacher_module_homework_usecase.dart';
import 'package:elara/features/teacher/domain/homework/usecases/get_teacher_student_submission_usecase.dart';
import 'package:elara/features/teacher/domain/homework/usecases/update_teacher_problem_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ── State ──────────────────────────────────────────────────────────────────────

sealed class TeacherHomeworkState extends Equatable {
  const TeacherHomeworkState();
  @override
  List<Object?> get props => [];
}

final class TeacherHomeworkInitial extends TeacherHomeworkState {
  const TeacherHomeworkInitial();
}

final class TeacherHomeworkLoading extends TeacherHomeworkState {
  const TeacherHomeworkLoading();
}

final class TeacherHomeworkLoaded extends TeacherHomeworkState {
  final TeacherHomeworkEntity homework;
  const TeacherHomeworkLoaded(this.homework);
  @override
  List<Object?> get props => [homework];
}

final class TeacherHomeworkError extends TeacherHomeworkState {
  final String message;
  const TeacherHomeworkError(this.message);
  @override
  List<Object?> get props => [message];
}

// ── Cubit ──────────────────────────────────────────────────────────────────────

class TeacherHomeworkCubit extends Cubit<TeacherHomeworkState> {
  final GetTeacherModuleHomeworkUseCase _getHomeworkUseCase;
  final AddTeacherModuleProblemUseCase _addProblemUseCase;
  final UpdateTeacherProblemUseCase _updateProblemUseCase;
  final DeleteTeacherProblemUseCase _deleteProblemUseCase;
  final GetTeacherStudentSubmissionUseCase _getStudentSubmissionUseCase;

  TeacherHomeworkCubit(
    this._getHomeworkUseCase,
    this._addProblemUseCase,
    this._updateProblemUseCase,
    this._deleteProblemUseCase,
    this._getStudentSubmissionUseCase,
  ) : super(const TeacherHomeworkInitial());

  Future<void> load({required String moduleId, required String groupId}) async {
    emit(const TeacherHomeworkLoading());
    final result = await _getHomeworkUseCase(
      moduleId: moduleId,
      groupId: groupId,
    );
    emit(
      result.fold(
        onSuccess: TeacherHomeworkLoaded.new,
        onFailure: (failure) => TeacherHomeworkError(failure.message),
      ),
    );
  }

  Future<void> addProblem({
    required String moduleId,
    required String groupId,
    required String description,
  }) async {
    final trimmed = description.trim();
    if (trimmed.isEmpty) {
      return;
    }

    emit(const TeacherHomeworkLoading());
    final addResult = await _addProblemUseCase(
      moduleId: moduleId,
      description: trimmed,
    );

    if (!addResult.isSuccess) {
      emit(
        TeacherHomeworkError(
          addResult.failure?.message ?? 'Failed to add homework problem',
        ),
      );
      return;
    }

    await load(moduleId: moduleId, groupId: groupId);
  }

  Future<void> updateProblem({
    required String moduleId,
    required String groupId,
    required String problemId,
    required String description,
  }) async {
    final trimmed = description.trim();
    if (trimmed.isEmpty) {
      return;
    }

    emit(const TeacherHomeworkLoading());
    final result = await _updateProblemUseCase(
      problemId: problemId,
      description: trimmed,
    );

    if (!result.isSuccess) {
      emit(
        TeacherHomeworkError(
          result.failure?.message ?? 'Failed to update homework problem',
        ),
      );
      return;
    }

    await load(moduleId: moduleId, groupId: groupId);
  }

  Future<void> deleteProblem({
    required String moduleId,
    required String groupId,
    required String problemId,
  }) async {
    emit(const TeacherHomeworkLoading());
    final result = await _deleteProblemUseCase(problemId: problemId);

    if (!result.isSuccess) {
      emit(
        TeacherHomeworkError(
          result.failure?.message ?? 'Failed to delete homework problem',
        ),
      );
      return;
    }

    await load(moduleId: moduleId, groupId: groupId);
  }

  /// Fetches full answer details for a specific student.
  /// Returns the entity on success, or null on failure (failure is silent).
  Future<TeacherStudentSubmissionDetailEntity?> loadStudentSubmission({
    required String moduleId,
    required String studentId,
    required String groupId,
  }) async {
    final result = await _getStudentSubmissionUseCase(
      moduleId: moduleId,
      studentId: studentId,
      groupId: groupId,
    );
    return result.fold(
      onSuccess: (detail) => detail,
      onFailure: (_) => null,
    );
  }
}
