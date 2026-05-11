import 'package:elara/features/settings/presentation/cubits/password_security_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Password & Security — presentation-only until backend exists.
class PasswordSecurityCubit extends Cubit<PasswordSecurityState> {
  PasswordSecurityCubit() : super(const PasswordSecurityState());

  void setCurrentPassword(String value) {
    emit(state.copyWith(currentPassword: value));
  }

  void setNewPassword(String value) {
    emit(state.copyWith(newPassword: value));
  }

  void setConfirmPassword(String value) {
    emit(state.copyWith(confirmPassword: value));
  }

  void toggleObscureCurrent() {
    emit(state.copyWith(obscureCurrent: !state.obscureCurrent));
  }

  void toggleObscureNew() {
    emit(state.copyWith(obscureNew: !state.obscureNew));
  }

  void toggleObscureConfirm() {
    emit(state.copyWith(obscureConfirm: !state.obscureConfirm));
  }

  void submit() {
    if (state.currentPassword.isEmpty ||
        state.newPassword.isEmpty ||
        state.confirmPassword.isEmpty) {
      emit(state.copyWith(pendingSnackMessage: 'Please fill all fields.'));
      return;
    }
    if (state.newPassword != state.confirmPassword) {
      emit(state.copyWith(pendingSnackMessage: 'New passwords do not match.'));
      return;
    }
    emit(state.copyWith(pendingSnackMessage: 'Password updated (demo).'));
  }

  void clearSnackMessage() {
    emit(state.copyWith(clearSnackMessage: true));
  }
}
