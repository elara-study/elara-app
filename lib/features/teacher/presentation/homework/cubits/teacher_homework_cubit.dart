import 'package:elara/features/teacher/domain/homework/entities/teacher_homework_entity.dart';
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
  final GetTeacherModuleHomeworkUseCase _useCase;

  TeacherHomeworkCubit(this._useCase) : super(const TeacherHomeworkInitial());

  Future<void> load({required String moduleId, required String groupId}) async {
    emit(const TeacherHomeworkLoading());
    try {
      final homework = await _useCase(moduleId: moduleId, groupId: groupId);
      emit(TeacherHomeworkLoaded(homework));
    } catch (e) {
      emit(TeacherHomeworkError(e.toString()));
    }
  }
}
