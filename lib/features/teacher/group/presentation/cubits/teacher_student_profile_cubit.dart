import 'package:elara/features/teacher/group/domain/usecases/get_teacher_student_profile_usecase.dart';
import 'package:elara/features/teacher/group/domain/usecases/get_teacher_student_insights_usecase.dart';
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
  TeacherStudentProfileCubit({
    required GetTeacherStudentProfileUseCase getProfile,
    required GetTeacherStudentInsightsUseCase getInsights,
  })  : _getProfile = getProfile,
        _getInsights = getInsights,
        super(const TeacherStudentProfileInitial());

  final GetTeacherStudentProfileUseCase _getProfile;
  final GetTeacherStudentInsightsUseCase _getInsights;

  Future<void> loadProfile({
    required String groupId,
    required int studentRank,
  }) async {
    emit(const TeacherStudentProfileLoading());
    final profileResult = await _getProfile(groupId: groupId, studentRank: studentRank);
    
    await profileResult.fold(
      (failure) async => emit(TeacherStudentProfileError(failure.message)),
      (profile) async {
        final insightResult = await _getInsights(profile.student.id);
        TeacherStudentProfileEntity currentProfile = profile;
        
        insightResult.fold(
          (_) {}, // Failed to get insight, just leave profile without it
          (insight) {
            if (insight != null) {
              currentProfile = profile.copyWith(insight: insight);
            }
          },
        );
        
        emit(TeacherStudentProfileLoaded(currentProfile));
      },
    );
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
