import 'package:elara/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:elara/features/auth/presentation/cubits/auth_state.dart';
import 'package:elara/features/parent/domain/profile/usecases/get_parent_profile_use_case.dart';
import 'package:elara/features/parent/presentation/profile/cubits/parent_profile_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ParentProfileCubit extends Cubit<ParentProfileState> {
  final AuthCubit _authCubit;
  final GetParentProfileUseCase _getProfileUseCase;

  ParentProfileCubit({
    required AuthCubit authCubit,
    required GetParentProfileUseCase getProfileUseCase,
  })  : _authCubit = authCubit,
        _getProfileUseCase = getProfileUseCase,
        super(const ParentProfileState());

  Future<void> loadProfile() async {
    if (isClosed) return;
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      final profileData = await _getProfileUseCase();
      if (isClosed) return;
      emit(state.copyWith(isLoading: false, profileData: profileData));
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

  Future<void> logout() async {
    await _authCubit.logout();
    if (_authCubit.state is AuthUnauthenticated) {
      emit(state.copyWith(shouldNavigateToLogin: true));
    }
  }
}
