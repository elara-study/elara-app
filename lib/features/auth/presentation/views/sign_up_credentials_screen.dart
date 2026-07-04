import 'package:elara/core/navigation/app_navigation.dart';
import 'package:elara/config/routes.dart';
import 'package:elara/core/enums/user_role.dart';
import 'package:elara/core/utils/app_snackbar.dart';
import 'package:elara/features/auth/auth.dart';
import 'package:elara/shared/widgets/app_glass_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SignUpCredentialsScreen extends StatelessWidget {
  const SignUpCredentialsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = GoRouterState.of(context).extra;

    // Detect Google complete-registration flow.
    final UserRole role;
    final GooglePendingData? googleData;

    if (args is ({UserRole role, GooglePendingData googleData})) {
      role = args.role;
      googleData = args.googleData;
    } else {
      role = args as UserRole;
      googleData = null;
    }

    final isGoogleFlow = googleData != null;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const AppGlassHeader(
        title: 'Credentials',
        showDivider: false,
        automaticallyImplyLeading: true,
      ),
      body: BlocConsumer<AuthCubit, AuthState>(
        listenWhen: (previous, current) {
          if (current is AuthNeedsVerification) {
            return previous is! AuthNeedsVerification;
          }
          return current is AuthNeedsVerification || current is AuthError;
        },
        listener: _onAuthStateChange,
        builder: (context, state) => AuthScreenLayout(
          builder: (_, __) => SignUpForm(
            role: role,
            isLoading: state is AuthLoading,
            isGoogleFlow: isGoogleFlow,
            onSubmit: ({
              required name,
              required email,
              required password,
              required dateOfBirth,
              String? subjectDisplayName,
              int? grade,
            }) {
              if (isGoogleFlow) {
                context.read<AuthCubit>().completeRegistration(
                  pendingToken: googleData!.pendingToken,
                  role: role,
                  dateOfBirth: dateOfBirth,
                  subjectDisplayName: subjectDisplayName,
                  grade: grade,
                );
              } else {
                context.read<AuthCubit>().signUp(
                  name: name,
                  email: email,
                  password: password,
                  role: role,
                  dateOfBirth: dateOfBirth,
                  subjectDisplayName: subjectDisplayName,
                  grade: grade,
                );
              }
            },
          ),
        ),
      ),
    );
  }

  static void _onAuthStateChange(BuildContext context, AuthState state) {
    if (state is AuthNeedsVerification) {
      AppNavigation.pushNamed(
        context,
        AppRoutes.otp,
        arguments: OtpRouteArgs.emailVerification(
          email: state.email,
          pendingUser: state.pendingUser,
        ),
      );
    } else if (state is AuthError) {
      AppSnackBar.error(context, state.message);
    }
  }
}
