import 'package:elara/features/teacher/domain/homework/entities/teacher_resource_entity.dart';
import 'package:elara/features/teacher/domain/homework/usecases/get_teacher_module_resources_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ── State ──────────────────────────────────────────────────────────────────────

sealed class StudentResourcesState extends Equatable {
  const StudentResourcesState();
  @override
  List<Object?> get props => [];
}

final class StudentResourcesInitial extends StudentResourcesState {
  const StudentResourcesInitial();
}

final class StudentResourcesLoading extends StudentResourcesState {
  const StudentResourcesLoading();
}

final class StudentResourcesLoaded extends StudentResourcesState {
  final List<TeacherResourceEntity> resources;
  const StudentResourcesLoaded(this.resources);
  @override
  List<Object?> get props => [resources];
}

final class StudentResourcesError extends StudentResourcesState {
  final String message;
  const StudentResourcesError(this.message);
  @override
  List<Object?> get props => [message];
}

// ── Cubit ──────────────────────────────────────────────────────────────────────

class StudentResourcesCubit extends Cubit<StudentResourcesState> {
  final GetTeacherModuleResourcesUseCase _useCase;

  StudentResourcesCubit(this._useCase)
      : super(const StudentResourcesInitial());

  Future<void> load({required String moduleId, required String groupId}) async {
    emit(const StudentResourcesLoading());
    final result = await _useCase(moduleId: moduleId, groupId: groupId);
    emit(
      result.fold(
        onSuccess: StudentResourcesLoaded.new,
        onFailure: (failure) => StudentResourcesError(failure.message),
      ),
    );
  }
}
