import 'package:elara/features/teacher/domain/homework/entities/teacher_resource_entity.dart';
import 'package:elara/features/teacher/domain/homework/usecases/get_teacher_module_resources_usecase.dart';
import 'package:elara/features/teacher/domain/homework/usecases/add_teacher_module_resource_usecase.dart';
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
  final AddTeacherModuleResourceUseCase _addUseCase;

  TeacherResourcesCubit(this._useCase, this._addUseCase)
      : super(const TeacherResourcesInitial());

  Future<void> load({required String moduleId, required String groupId}) async {
    emit(const TeacherResourcesLoading());
    final result = await _useCase(moduleId: moduleId, groupId: groupId);
    emit(
      result.fold(
        onSuccess: TeacherResourcesLoaded.new,
        onFailure: (failure) => TeacherResourcesError(failure.message),
      ),
    );
  }
  Future<void> addResource({
    required String moduleId,
    required String groupId,
    required String title,
    required String filePath,
  }) async {
    emit(const TeacherResourcesLoading());
    final result = await _addUseCase(
      moduleId: moduleId,
      title: title,
      filePath: filePath,
    );
    result.fold(
      onSuccess: (_) => load(moduleId: moduleId, groupId: groupId),
      onFailure: (failure) => emit(TeacherResourcesError(failure.message)),
    );
  }
}
