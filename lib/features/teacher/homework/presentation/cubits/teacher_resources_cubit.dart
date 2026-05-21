import 'package:elara/features/teacher/homework/domain/entities/teacher_resource_entity.dart';
import 'package:elara/features/teacher/homework/domain/usecases/get_teacher_module_resources_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ── State ──────────────────────────────────────────────────────────────────────

sealed class TeacherResourcesState extends Equatable {
  const TeacherResourcesState();
  @override
  List<Object?> get props => [];
}

final class TeacherResourcesInitial extends TeacherResourcesState {
  const TeacherResourcesInitial();
}

final class TeacherResourcesLoading extends TeacherResourcesState {
  const TeacherResourcesLoading();
}

final class TeacherResourcesLoaded extends TeacherResourcesState {
  final List<TeacherResourceEntity> resources;
  const TeacherResourcesLoaded(this.resources);
  @override
  List<Object?> get props => [resources];
}

final class TeacherResourcesError extends TeacherResourcesState {
  final String message;
  const TeacherResourcesError(this.message);
  @override
  List<Object?> get props => [message];
}

// ── Cubit ──────────────────────────────────────────────────────────────────────

class TeacherResourcesCubit extends Cubit<TeacherResourcesState> {
  final GetTeacherModuleResourcesUseCase _useCase;

  TeacherResourcesCubit(this._useCase) : super(const TeacherResourcesInitial());

  Future<void> load({required String moduleId, required String groupId}) async {
    emit(const TeacherResourcesLoading());
    try {
      final resources = await _useCase(moduleId: moduleId, groupId: groupId);
      emit(TeacherResourcesLoaded(resources));
    } catch (e) {
      emit(TeacherResourcesError(e.toString()));
    }
  }
}
