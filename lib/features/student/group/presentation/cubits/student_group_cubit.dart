import 'package:elara/core/error/failures.dart';
import 'package:elara/features/student/group/domain/entities/group_leaderboard_entry.dart';
import 'package:elara/features/student/group/domain/entities/student_group_overview.dart';
import 'package:elara/features/student/group/domain/usecases/load_student_group_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'student_group_state.dart';

class StudentGroupCubit extends Cubit<StudentGroupState> {
  final LoadStudentGroupUseCase _loadStudentGroup;

  StudentGroupCubit(this._loadStudentGroup)
    : super(const StudentGroupState.initial());

  /// Loads [StudentGroupOverview] and leaderboard for [groupId].
  Future<void> loadGroup({required String groupId}) async {
    emit(const StudentGroupState.loading());

    final result = await _loadStudentGroup(groupId: groupId);
    emit(
      result.fold(
        onSuccess: (data) => StudentGroupState.loaded(
          overview: data.overview,
          leaderboard: data.leaderboard,
        ),
        onFailure: (failure) => StudentGroupState.failure(
          message: failure.message,
          failure: failure,
        ),
      ),
    );
  }
}
