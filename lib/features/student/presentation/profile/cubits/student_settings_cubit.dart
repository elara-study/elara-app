import 'package:elara/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:elara/features/auth/presentation/cubits/auth_state.dart';
import 'package:elara/features/student/presentation/profile/cubits/student_settings_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StudentSettingsCubit extends Cubit<StudentSettingsState> {
  StudentSettingsCubit({required AuthCubit authCubit})
    : _authCubit = authCubit,
      super(const StudentSettingsState());

  final AuthCubit _authCubit;

  void requestLanguagePlaceholderSnack() {
    emit(state.copyWith(pendingSnackMessage: 'Language picker coming soon.'));
  }

  void clearSnackMessage() {
    emit(state.copyWith(clearSnackMessage: true));
  }

  Future<void> logout() async {
    await _authCubit.logout();
    if (_authCubit.state is AuthUnauthenticated) {
      emit(state.copyWith(shouldNavigateToLogin: true));
    }
  }
}
