import 'package:elara/features/teacher/domain/dashboard/usecases/get_teacher_dashboard_usecase.dart';
import 'package:elara/features/teacher/presentation/profile/cubits/teacher_profile_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TeacherProfileCubit extends Cubit<TeacherProfileState> {
  final GetTeacherDashboardUseCase _getTeacherDashboard;

  TeacherProfileCubit({required GetTeacherDashboardUseCase getTeacherDashboard})
    : _getTeacherDashboard = getTeacherDashboard,
      super(const TeacherProfileState());

  Future<void> loadProfile() async {
    if (isClosed) return;
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      final result = await _getTeacherDashboard();
      if (isClosed) return;
      result.fold(
        (failure) => emit(
          state.copyWith(isLoading: false, errorMessage: failure.message),
        ),
        (dashboard) => emit(
          state.copyWith(isLoading: false, profileData: dashboard.profile),
        ),
      );
    } catch (e) {
      if (isClosed) return;
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  void requestPlaceholderSnack(String message) {
    emit(state.copyWith(pendingSnackMessage: message));
  }

  void clearSnackMessage() {
    emit(state.copyWith(clearSnackMessage: true));
  }
}
