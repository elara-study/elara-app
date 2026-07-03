import 'package:elara/features/parent/domain/children/usecases/get_parent_child_profile_use_case.dart';
import 'package:elara/features/parent/domain/children/usecases/unlink_child_use_case.dart';
import 'package:elara/features/parent/presentation/children/cubits/parent_child_profile_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ParentChildProfileCubit extends Cubit<ParentChildProfileState> {
  ParentChildProfileCubit({
    required GetParentChildProfileUseCase getProfile,
    required UnlinkChildUseCase unlinkChildUseCase,
  }) : _getProfile = getProfile,
       _unlinkChild = unlinkChildUseCase,
       super(const ParentChildProfileInitial());

  final GetParentChildProfileUseCase _getProfile;
  final UnlinkChildUseCase _unlinkChild;

  Future<void> loadProfile(String childId) async {
    emit(const ParentChildProfileLoading());
    try {
      final profile = await _getProfile(childId);
      emit(ParentChildProfileLoaded(profile));
    } catch (e) {
      emit(ParentChildProfileError(e.toString()));
    }
  }

  Future<bool> unlinkChild(String childId) async {
    emit(const ParentChildProfileLoading());
    try {
      await _unlinkChild(childId);
      return true;
    } catch (e) {
      emit(ParentChildProfileError(e.toString()));
      return false;
    }
  }
}
