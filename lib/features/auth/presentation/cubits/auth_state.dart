import 'package:elara/core/enums/user_role.dart';
import 'package:elara/features/auth/domain/entities/user_entity.dart';
import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthGoogleLoading extends AuthState {
  const AuthGoogleLoading();
}

class AuthAuthenticated extends AuthState {
  final UserEntity user;

  const AuthAuthenticated(this.user);

  @override
  List<Object?> get props => [user];
}

class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object?> get props => [message];
}

/// Emitted when a role is selected on the Sign Up Role screen
class RoleSelected extends AuthState {
  final UserRole role;

  const RoleSelected(this.role);

  @override
  List<Object?> get props => [role];
}

class AuthNeedsVerification extends AuthState {
  final String email;
  final UserEntity pendingUser;

  const AuthNeedsVerification({
    required this.email,
    required this.pendingUser,
  });

  @override
  List<Object?> get props => [email, pendingUser];
}

/// Emitted after POST /forgot-password succeeds — carries email to OTP screen.
class ForgotPasswordOtpSent extends AuthState {
  final String email;

  const ForgotPasswordOtpSent(this.email);

  @override
  List<Object?> get props => [email];
}

/// Emitted when the OTP is verified in the reset-password flow.
/// Carries email + otp to the ResetPasswordScreen.
class ResetPasswordReady extends AuthState {
  final String email;
  final String otp;

  const ResetPasswordReady({required this.email, required this.otp});

  @override
  List<Object?> get props => [email, otp];
}

/// Emitted after POST /reset-password succeeds — navigate to login.
class PasswordResetSuccess extends AuthState {
  const PasswordResetSuccess();
}

/// Emitted when Google sign-in succeeds but the JWT has no role claim.
/// Carries the pending tokens so the UI can route to role-selection +
/// complete-registration.
class GoogleSignInNeedsRole extends AuthState {
  final String pendingToken;
  final String refreshToken;

  const GoogleSignInNeedsRole({
    required this.pendingToken,
    required this.refreshToken,
  });

  @override
  List<Object?> get props => [pendingToken, refreshToken];
}
