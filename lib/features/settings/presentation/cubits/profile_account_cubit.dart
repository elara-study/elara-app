import 'package:elara/core/error/failures.dart';
import 'package:elara/features/settings/domain/usecases/get_profile_account_use_case.dart';
import 'package:elara/features/settings/presentation/cubits/profile_account_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Profile & Account — loads [ProfileAccountEntity] via [GetProfileAccountUseCase].
class ProfileAccountCubit extends Cubit<ProfileAccountState> {
  ProfileAccountCubit(this._getProfileAccount)
    : super(const ProfileAccountInitial());

  final GetProfileAccountUseCase _getProfileAccount;

  Future<void> loadProfile() async {
    emit(const ProfileAccountLoading());
    try {
      final profile = await _getProfileAccount();
      emit(ProfileAccountLoaded(profile: profile));
    } on Failure catch (f) {
      emit(ProfileAccountError(f.message));
    } catch (e) {
      emit(ProfileAccountError(_message(e)));
    }
  }

  void saveChanges() {
    final current = state;
    if (current is ProfileAccountLoaded) {
      emit(current.copyWith(pendingSnackMessage: 'Profile updated (demo).'));
    }
  }

  void deleteAccount() {
    final current = state;
    if (current is ProfileAccountLoaded) {
      emit(
        current.copyWith(
          pendingSnackMessage: 'Account deletion is not available yet.',
        ),
      );
    }
  }

  void clearSnackMessage() {
    final current = state;
    if (current is ProfileAccountLoaded) {
      emit(current.copyWith(clearSnackMessage: true));
    }
  }

  String _message(Object e) {
    if (e is Exception) {
      return e.toString().replaceAll('Exception: ', '');
    }
    return e.toString();
  }
}
