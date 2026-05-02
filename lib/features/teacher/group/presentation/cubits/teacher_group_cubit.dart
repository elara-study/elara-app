import 'package:elara/features/teacher/group/data/datasources/teacher_group_data_source.dart';
import 'package:elara/features/teacher/group/domain/entities/teacher_group_detail_entity.dart';
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

// ── Cubit ────────────────────────────────────────────────────────────────────

class TeacherGroupCubit extends Cubit<TeacherGroupState> {
  final TeacherGroupDataSource _dataSource;

  TeacherGroupCubit(this._dataSource) : super(const TeacherGroupInitial());

  Future<void> loadGroup(String groupId) async {
    emit(const TeacherGroupLoading());
    try {
      final detail = await _dataSource.getGroupDetail(groupId);
      emit(TeacherGroupLoaded(detail));
    } catch (e) {
      emit(TeacherGroupError(e.toString()));
    }
  }
}
