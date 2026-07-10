import 'package:elara/core/enums/subject_type.dart';
import 'package:elara/core/enums/user_role.dart';
import 'package:elara/core/error/exceptions.dart';
import 'package:elara/features/auth/data/models/user_model.dart';
import 'package:elara/features/auth/domain/entities/user_entity.dart';
import 'package:elara/features/auth/domain/usecases/complete_registration_use_case.dart';
import 'package:elara/features/auth/domain/usecases/forgot_password_use_case.dart';
import 'package:elara/features/auth/domain/usecases/get_current_user_use_case.dart';
import 'package:elara/features/auth/domain/usecases/google_sign_in_use_case.dart';
import 'package:elara/features/auth/domain/usecases/login_use_case.dart';
import 'package:elara/features/auth/domain/usecases/logout_use_case.dart';
import 'package:elara/features/auth/domain/usecases/register_use_case.dart';
import 'package:elara/features/auth/domain/usecases/reset_password_use_case.dart';
import 'package:elara/features/auth/domain/usecases/verify_email_use_case.dart';
import 'package:elara/features/auth/presentation/cubits/auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthCubit extends Cubit<AuthState> {
  final LoginUseCase _loginUseCase;
  final RegisterUseCase _registerUseCase;
  final VerifyEmailUseCase _verifyEmailUseCase;
  final ForgotPasswordUseCase _forgotPasswordUseCase;
  final ResetPasswordUseCase _resetPasswordUseCase;
  final GoogleSignInUseCase _googleSignInUseCase;
  final CompleteRegistrationUseCase _completeRegistrationUseCase;
  final LogoutUseCase _logoutUseCase;
  final GetCurrentUserUseCase _getCurrentUserUseCase;

  AuthCubit({
    required LoginUseCase loginUseCase,
    required RegisterUseCase registerUseCase,
    required VerifyEmailUseCase verifyEmailUseCase,
    required ForgotPasswordUseCase forgotPasswordUseCase,
    required ResetPasswordUseCase resetPasswordUseCase,
    required GoogleSignInUseCase googleSignInUseCase,
    required CompleteRegistrationUseCase completeRegistrationUseCase,
    required LogoutUseCase logoutUseCase,
    required GetCurrentUserUseCase getCurrentUserUseCase,
  }) : _loginUseCase = loginUseCase,
       _registerUseCase = registerUseCase,
       _verifyEmailUseCase = verifyEmailUseCase,
       _forgotPasswordUseCase = forgotPasswordUseCase,
       _resetPasswordUseCase = resetPasswordUseCase,
       _googleSignInUseCase = googleSignInUseCase,
       _completeRegistrationUseCase = completeRegistrationUseCase,
       _logoutUseCase = logoutUseCase,
       _getCurrentUserUseCase = getCurrentUserUseCase,
       super(const AuthInitial());

  /// Check if a user session already exists (called on Splash)
  Future<void> checkAuthStatus() async {
    emit(const AuthLoading());
    try {
      final user = await _getCurrentUserUseCase();
      if (user != null) {
        emit(AuthAuthenticated(user));
      } else {
        emit(const AuthUnauthenticated());
      }
    } catch (_) {
      emit(const AuthUnauthenticated());
    }
  }

  /// Sign in with email + password
  Future<void> signIn({required String email, required String password}) async {
    emit(const AuthLoading());
    try {
      final user = await _loginUseCase(email: email, password: password);
      emit(AuthAuthenticated(user));
    } on EmailNotVerifiedException catch (e) {
      emit(_pendingVerificationState(e.email));
    } catch (e) {
      final message = _extractMessage(e);
      if (_isEmailNotVerifiedMessage(message)) {
        emit(_pendingVerificationState(email));
        return;
      }
      emit(AuthError(message));
    }
  }

  /// Register with full credentials and a selected role
  Future<void> signUp({
    required String name,
    required String email,
    required String password,
    required UserRole role,
    required DateTime dateOfBirth,
    String? subjectDisplayName,
    int? grade,
  }) async {
    emit(const AuthLoading());
    try {
      // Convert the display name (e.g. 'Physics') to its backend integer id.
      final subjectId = subjectDisplayName != null
          ? SubjectType.values
                .cast<SubjectType?>()
                .firstWhere(
                  (s) => s!.displayName == subjectDisplayName,
                  orElse: () => null,
                )
                ?.value
          : null;

      // register returns RegisteredUserData (no token yet).
      // Build a stub UserEntity to carry through to the OTP screen so
      // verifyEmail can reconstruct the full entity once the real token arrives.
      final registered = await _registerUseCase(
        name: name,
        email: email,
        password: password,
        role: role,
        dateOfBirth: dateOfBirth,
        subjectId: subjectId,
        grade: grade,
      );
      final pendingUser = UserModel(
        id: registered.userId,
        fullName: registered.name,
        email: registered.email,
        role:
            role, // preserved from the form — RegisteredUserData.role is a String
        token: '', // placeholder; real token comes from verifyEmail
      );
      emit(AuthNeedsVerification(email: email, pendingUser: pendingUser));
    } catch (e) {
      emit(AuthError(_extractMessage(e)));
    }
  }

  /// Verify email with OTP — backend now returns a real token pair.
  /// [pendingUser] is carried from [AuthNeedsVerification] by the OTP screen.
  Future<void> verifyEmail({
    required String email,
    required String otp,
    required UserEntity pendingUser,
  }) async {
    emit(const AuthLoading());
    try {
      final verifiedUser = await _verifyEmailUseCase(
        email: email,
        otp: otp,
        pendingUser: pendingUser,
      );
      emit(AuthAuthenticated(verifiedUser));
    } catch (e) {
      emit(AuthError(_extractMessage(e)));
    }
  }

  /// Emit role selection (transient — consumed by SignUpCredentialsScreen)
  void selectRole(UserRole role) {
    emit(RoleSelected(role));
  }

  /// Clears persisted session when tokens expire (e.g. 401 from interceptor).
  Future<void> sessionExpired() async {
    try {
      await _logoutUseCase();
    } catch (_) {
      // Still force unauthenticated UI even if local clear fails.
    }
    emit(const AuthUnauthenticated());
  }

  /// Sign out current user
  Future<void> logout() async {
    emit(const AuthLoading());
    try {
      await _logoutUseCase();
      emit(const AuthUnauthenticated());
    } catch (e) {
      emit(AuthError(_extractMessage(e)));
    }
  }

  /// Request a password-reset OTP for the given email.
  Future<void> forgotPassword({required String email}) async {
    emit(const AuthLoading());
    try {
      await _forgotPasswordUseCase(email: email);
      emit(ForgotPasswordOtpSent(email));
    } catch (e) {
      emit(AuthError(_extractMessage(e)));
    }
  }

  /// Reset password with the OTP received via email.
  Future<void> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    emit(const AuthLoading());
    try {
      await _resetPasswordUseCase(
        email: email,
        otp: otp,
        newPassword: newPassword,
      );
      emit(const PasswordResetSuccess());
    } catch (e) {
      emit(AuthError(_extractMessage(e)));
    }
  }

  /// Google Sign-In: triggers Google SDK, sends idToken to backend.
  Future<void> signInWithGoogle() async {
    emit(const AuthGoogleLoading());
    try {
      final clientId = dotenv.env['GOOGLE_WEB_CLIENT_ID'] ?? '';
      final googleSignIn = GoogleSignIn(serverClientId: clientId);
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        // User cancelled the Google sign-in dialog.
        emit(const AuthInitial());
        return;
      }

      final googleAuth = await googleUser.authentication;
      final idToken = googleAuth.idToken;
      if (idToken == null || idToken.isEmpty) {
        emit(const AuthError('Failed to get Google ID token'));
        return;
      }

      final user = await _googleSignInUseCase(idToken: idToken);
      emit(AuthAuthenticated(user));
    } on NeedsRoleException catch (e) {
      emit(
        GoogleSignInNeedsRole(
          pendingToken: e.pendingToken,
          refreshToken: e.refreshToken,
        ),
      );
    } catch (e) {
      emit(AuthError(_extractMessage(e)));
    }
  }

  /// Complete registration for a Google-authenticated user (needs role + dob).
  Future<void> completeRegistration({
    required String pendingToken,
    required UserRole role,
    required DateTime dateOfBirth,
    String? subjectDisplayName,
    int? grade,
  }) async {
    emit(const AuthLoading());
    try {
      final subjectId = subjectDisplayName != null
          ? SubjectType.values
                .cast<SubjectType?>()
                .firstWhere(
                  (s) => s!.displayName == subjectDisplayName,
                  orElse: () => null,
                )
                ?.value
          : null;

      final user = await _completeRegistrationUseCase(
        pendingToken: pendingToken,
        role: role,
        dateOfBirth: dateOfBirth,
        subjectId: subjectId,
        grade: grade,
      );
      emit(AuthAuthenticated(user));
    } catch (e) {
      emit(AuthError(_extractMessage(e)));
    }
  }

  AuthNeedsVerification _pendingVerificationState(String email) {
    return AuthNeedsVerification(
      email: email,
      pendingUser: UserModel(
        id: '',
        fullName: '',
        email: email,
        role: UserRole.student,
        token: '',
      ),
    );
  }

  bool _isEmailNotVerifiedMessage(String message) {
    final lower = message.toLowerCase();
    return lower.contains('verify') && lower.contains('email');
  }

  String _extractMessage(Object e) {
    final msg = e.toString();
    if (msg.contains('ApiException: 10')) {
      return 'Google Sign-In Error (10): Developer console misconfiguration. Make sure your debug keystore SHA-1 is registered for com.example.elara on Google Cloud/Firebase.';
    }
    if (msg.contains('ApiException: 12500')) {
      return 'Google Sign-In Error (12500): Sign-in failed. Please verify package name, SHA-1 signature, and client ID configuration.';
    }
    if (msg.contains('ApiException: 7')) {
      return 'Google Sign-In Error (7): Network error. Please check your internet connection.';
    }
    if (e is Exception) {
      return e.toString().replaceAll('Exception: ', '');
    }
    return msg;
  }
}
