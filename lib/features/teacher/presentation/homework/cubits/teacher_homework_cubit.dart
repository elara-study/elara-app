import 'package:elara/features/teacher/domain/homework/entities/teacher_homework_entity.dart';
import 'package:elara/features/teacher/domain/homework/usecases/add_teacher_module_problem_usecase.dart';
import 'package:elara/features/teacher/domain/homework/usecases/get_teacher_module_homework_usecase.dart';
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

  TeacherHomeworkCubit(this._getHomeworkUseCase, this._addProblemUseCase)
    : super(const TeacherHomeworkInitial());

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
}
