import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:elara/features/teacher/domain/group/usecases/get_teacher_groups_usecase.dart';
import 'package:elara/features/teacher/domain/group/usecases/create_teacher_group_usecase.dart';
import 'package:elara/features/teacher/presentation/group/cubits/teacher_groups_state.dart';

class TeacherGroupsCubit extends Cubit<TeacherGroupsState> {
  final GetTeacherGroupsUseCase _getTeacherGroupsUseCase;
  final CreateTeacherGroupUseCase _createTeacherGroupUseCase;

  TeacherGroupsCubit(
    this._getTeacherGroupsUseCase,
    this._createTeacherGroupUseCase,
  ) : super(const TeacherGroupsInitial());

  Future<void> loadGroups() async {
    emit(const TeacherGroupsLoading());
    final result = await _getTeacherGroupsUseCase();
    result.fold(
      (failure) => emit(TeacherGroupsError(message: failure.message)),
      (groups) => emit(TeacherGroupsLoaded(groups: groups)),
    );
  }

  Future<void> createGroup({
    required String title,
    required String subject,
    required String grade,
    required String roadmapName,
  }) async {
    emit(const TeacherGroupsLoading());
    final result = await _createTeacherGroupUseCase(
      title: title,
      subject: subject,
      grade: grade,
      roadmapName: roadmapName,
    );

    result.fold(
      (failure) => emit(TeacherGroupsError(message: failure.message)),
      (_) => loadGroups(), // Reload groups after creation
    );
  }
}
