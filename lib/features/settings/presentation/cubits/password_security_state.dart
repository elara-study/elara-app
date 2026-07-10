import 'package:equatable/equatable.dart';

/// Password & Security UI state (Figma target: node 432:2658).
class PasswordSecurityState extends Equatable {
  const PasswordSecurityState({
    this.currentPassword = '',
    this.newPassword = '',
    this.confirmPassword = '',
    this.obscureCurrent = true,
    this.obscureNew = true,
    this.obscureConfirm = true,
    this.pendingSnackMessage,
  });

  final String currentPassword;
  final String newPassword;
  final String confirmPassword;
  final bool obscureCurrent;
  final bool obscureNew;
  final bool obscureConfirm;
  final String? pendingSnackMessage;

  PasswordSecurityState copyWith({
    String? currentPassword,
    String? newPassword,
    String? confirmPassword,
    bool? obscureCurrent,
    bool? obscureNew,
    bool? obscureConfirm,
    String? pendingSnackMessage,
    bool clearSnackMessage = false,
  }) {
    return PasswordSecurityState(
      currentPassword: currentPassword ?? this.currentPassword,
      newPassword: newPassword ?? this.newPassword,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      obscureCurrent: obscureCurrent ?? this.obscureCurrent,
      obscureNew: obscureNew ?? this.obscureNew,
      obscureConfirm: obscureConfirm ?? this.obscureConfirm,
      pendingSnackMessage: clearSnackMessage
          ? null
          : (pendingSnackMessage ?? this.pendingSnackMessage),
    );
  }

  @override
  List<Object?> get props => [
    currentPassword,
    newPassword,
    confirmPassword,
    obscureCurrent,
    obscureNew,
    obscureConfirm,
    pendingSnackMessage,
  ];
}
