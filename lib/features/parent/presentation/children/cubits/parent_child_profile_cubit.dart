import 'package:elara/features/parent/domain/children/usecases/get_parent_child_profile_use_case.dart';
import 'package:elara/features/parent/presentation/children/cubits/parent_child_profile_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ParentChildProfileCubit extends Cubit<ParentChildProfileState> {
  ParentChildProfileCubit({
    required GetParentChildProfileUseCase getProfile,
  }) : _getProfile = getProfile,
       super(const ParentChildProfileInitial());

  final GetParentChildProfileUseCase _getProfile;

  Future<void> loadProfile(String childId) async {
    emit(const ParentChildProfileLoading());
    try {
      final profile = await _getProfile(childId);
      emit(ParentChildProfileLoaded(profile));
    } catch (e) {
      emit(ParentChildProfileError(e.toString()));
    }
  }
}
