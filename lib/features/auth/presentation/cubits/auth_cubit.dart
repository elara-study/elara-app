import 'package:elara/core/enums/subject_type.dart';
import 'package:elara/core/enums/user_role.dart';
import 'package:elara/features/auth/domain/usecases/get_current_user_use_case.dart';
import 'package:elara/features/auth/domain/usecases/login_use_case.dart';
import 'package:elara/features/auth/domain/usecases/logout_use_case.dart';
import 'package:elara/features/auth/domain/usecases/register_use_case.dart';
import 'package:elara/features/auth/domain/usecases/verify_email_use_case.dart';
import 'package:elara/features/auth/presentation/cubits/auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthCubit extends Cubit<AuthState> {
  final LoginUseCase _loginUseCase;
  final RegisterUseCase _registerUseCase;
  final VerifyEmailUseCase _verifyEmailUseCase;
  final LogoutUseCase _logoutUseCase;
  final GetCurrentUserUseCase _getCurrentUserUseCase;

  AuthCubit({
    required LoginUseCase loginUseCase,
    required RegisterUseCase registerUseCase,
    required VerifyEmailUseCase verifyEmailUseCase,
    required LogoutUseCase logoutUseCase,
    required GetCurrentUserUseCase getCurrentUserUseCase,
  }) : _loginUseCase = loginUseCase,
       _registerUseCase = registerUseCase,
       _verifyEmailUseCase = verifyEmailUseCase,
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
    } catch (e) {
      emit(AuthError(_extractMessage(e)));
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

      final user = await _registerUseCase(
        name: name,
        email: email,
        password: password,
        role: role,
        dateOfBirth: dateOfBirth,
        subjectId: subjectId,
        grade: grade,
      );
      emit(AuthNeedsVerification(user.email));
    } catch (e) {
      emit(AuthError(_extractMessage(e)));
    }
  }

  /// Verify email with OTP code
  Future<void> verifyEmail({required String email, required String otp}) async {
    emit(const AuthLoading());
    try {
      await _verifyEmailUseCase(email: email, otp: otp);
      emit(const AuthVerificationSuccess());
    } catch (e) {
      emit(AuthError(_extractMessage(e)));
    }
  }

  /// Emit role selection (transient — consumed by SignUpCredentialsScreen)
  void selectRole(UserRole role) {
    emit(RoleSelected(role));
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

  String _extractMessage(Object e) {
    if (e is Exception) {
      return e.toString().replaceAll('Exception: ', '');
    }
    return e.toString();
  }
}
