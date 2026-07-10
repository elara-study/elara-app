import 'package:elara/features/teacher/domain/group/usecases/get_teacher_group_detail_usecase.dart';
import 'package:elara/features/teacher/domain/group/usecases/add_teacher_group_student_usecase.dart';
import 'package:elara/features/teacher/domain/group/usecases/delete_teacher_group_usecase.dart';
import 'package:elara/features/teacher/domain/group/entities/teacher_group_detail_entity.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ── State ─────────────────────────────────────────────────────────────────────

sealed class TeacherGroupState extends Equatable {
  const TeacherGroupState();
  @override
  List<Object?> get props => [];
}

class TeacherGroupInitial extends TeacherGroupState {
  const TeacherGroupInitial();
}

class TeacherGroupLoading extends TeacherGroupState {
  const TeacherGroupLoading();
}

class TeacherGroupLoaded extends TeacherGroupState {
  final TeacherGroupDetailEntity detail;
  const TeacherGroupLoaded(this.detail);
  @override
  List<Object?> get props => [detail];
}

class TeacherGroupError extends TeacherGroupState {
  final String message;
  const TeacherGroupError(this.message);
  @override
  List<Object?> get props => [message];
}

class TeacherGroupDeleted extends TeacherGroupState {
  const TeacherGroupDeleted();
}

// ── Cubit ────────────────────────────────────────────────────────────────────

class TeacherGroupCubit extends Cubit<TeacherGroupState> {
  final GetTeacherGroupDetailUseCase _getGroupDetail;
  final AddTeacherGroupStudentUseCase _addStudent;

  final DeleteTeacherGroupUseCase _deleteGroup;

  TeacherGroupCubit({
    required GetTeacherGroupDetailUseCase getGroupDetail,
    required AddTeacherGroupStudentUseCase addStudent,
    required DeleteTeacherGroupUseCase deleteGroup,
  }) : _getGroupDetail = getGroupDetail,
       _addStudent = addStudent,
       _deleteGroup = deleteGroup,
       super(const TeacherGroupInitial());

  Future<void> loadGroup(String groupId) async {
    emit(const TeacherGroupLoading());
    final result = await _getGroupDetail(groupId);
    result.fold(
      (failure) => emit(TeacherGroupError(failure.message)),
      (detail) => emit(TeacherGroupLoaded(detail)),
    );
  }

  Future<void> addStudent({
    required String groupId,
    required String username,
  }) async {
    final result = await _addStudent(groupId, username);
    result.fold(
      (failure) => emit(TeacherGroupError(failure.message)),
      (_) => loadGroup(groupId),
    );
  }

  Future<void> deleteGroup(String groupId) async {
    emit(const TeacherGroupLoading());
    final result = await _deleteGroup(groupId);
    result.fold(
      (failure) => emit(TeacherGroupError(failure.message)),
      (_) => emit(const TeacherGroupDeleted()),
    );
  }
}
