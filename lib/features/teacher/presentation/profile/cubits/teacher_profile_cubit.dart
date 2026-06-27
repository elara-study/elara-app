import 'package:elara/features/teacher/domain/repositories/teacher_home_repository.dart';
import 'package:elara/features/teacher/presentation/profile/cubits/teacher_profile_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TeacherProfileCubit extends Cubit<TeacherProfileState> {
  final TeacherHomeRepository _repository;

  TeacherProfileCubit({required TeacherHomeRepository repository})
    : _repository = repository,
      super(const TeacherProfileState());

  Future<void> loadProfile() async {
    if (isClosed) return;
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      final result = await _repository.getProfile();
      if (isClosed) return;
      result.fold(
        (failure) => emit(
          state.copyWith(isLoading: false, errorMessage: failure.message),
        ),
        (profileData) =>
            emit(state.copyWith(isLoading: false, profileData: profileData)),
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
