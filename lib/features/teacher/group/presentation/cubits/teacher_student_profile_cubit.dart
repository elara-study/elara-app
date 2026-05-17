import 'package:elara/features/teacher/group/data/datasources/teacher_group_data_source.dart';
import 'package:elara/features/teacher/group/domain/entities/teacher_student_insight_entity.dart';
import 'package:elara/features/teacher/group/domain/entities/teacher_student_profile_entity.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

sealed class TeacherStudentProfileState extends Equatable {
  const TeacherStudentProfileState();

  @override
  List<Object?> get props => [];
}

class TeacherStudentProfileInitial extends TeacherStudentProfileState {
  const TeacherStudentProfileInitial();
}

class TeacherStudentProfileLoading extends TeacherStudentProfileState {
  const TeacherStudentProfileLoading();
}

class TeacherStudentProfileLoaded extends TeacherStudentProfileState {
  const TeacherStudentProfileLoaded(this.profile);

  final TeacherStudentProfileEntity profile;

  @override
  List<Object?> get props => [profile];
}

class TeacherStudentProfileError extends TeacherStudentProfileState {
  const TeacherStudentProfileError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

class TeacherStudentProfileCubit extends Cubit<TeacherStudentProfileState> {
  TeacherStudentProfileCubit(this._dataSource)
    : super(const TeacherStudentProfileInitial());

  final TeacherGroupDataSource _dataSource;

  Future<void> loadProfile({
    required String groupId,
    required int studentRank,
  }) async {
    emit(const TeacherStudentProfileLoading());
    try {
      final profile = await _dataSource.getStudentProfile(
        groupId: groupId,
        studentRank: studentRank,
      );
      emit(TeacherStudentProfileLoaded(profile));
    } catch (e) {
      emit(TeacherStudentProfileError(e.toString()));
    }
  }

  void saveInsight(List<String> paragraphs) {
    if (state is! TeacherStudentProfileLoaded) return;
    final currentProfile = (state as TeacherStudentProfileLoaded).profile;

    final newInsight = TeacherStudentInsightEntity(
      updatedLabel: 'Draft • Just now',
      paragraph1: paragraphs.isNotEmpty ? paragraphs[0] : '',
      paragraph2: paragraphs.length > 1 ? paragraphs[1] : '',
      isDraft: true,
    );

    final updatedProfile = currentProfile.copyWith(insight: newInsight);
    emit(TeacherStudentProfileLoaded(updatedProfile));
  }

  void sendInsight() {
    if (state is! TeacherStudentProfileLoaded) return;
    final currentProfile = (state as TeacherStudentProfileLoaded).profile;
    if (currentProfile.insight == null) return;

    final updatedInsight = TeacherStudentInsightEntity(
      updatedLabel: 'Sent • Just now',
      paragraph1: currentProfile.insight!.paragraph1,
      paragraph2: currentProfile.insight!.paragraph2,
      isDraft: false,
    );

    final updatedProfile = currentProfile.copyWith(insight: updatedInsight);
    emit(TeacherStudentProfileLoaded(updatedProfile));
  }
}
