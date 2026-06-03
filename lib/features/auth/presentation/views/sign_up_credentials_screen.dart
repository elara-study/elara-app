import 'package:elara/config/dependency_injection.dart';
import 'package:elara/config/routes.dart';
import 'package:elara/core/enums/user_role.dart';
import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/features/auth/auth.dart';
import 'package:elara/shared/widgets/app_glass_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpCredentialsScreen extends StatelessWidget {
  const SignUpCredentialsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final role = ModalRoute.of(context)!.settings.arguments as UserRole;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const AppGlassHeader(
        title: 'Credentials',
        showDivider: false,
        automaticallyImplyLeading: true,
      ),
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: _onAuthStateChange,
        builder: (context, state) => AuthScreenLayout(
          builder: (_, __) => SignUpForm(
            role: role,
            isLoading: state is AuthLoading,
            onSubmit: ({
              required name,
              required email,
              required password,
              required dateOfBirth,
              String? subjectDisplayName,
              int? grade,
            }) {
              context.read<AuthCubit>().signUp(
                name: name,
                email: email,
                password: password,
                role: role,
                dateOfBirth: dateOfBirth,
                subjectDisplayName: subjectDisplayName,
                grade: grade,
              );
            },
          ),
        ),
      ),
    );
  }

  static void _onAuthStateChange(BuildContext context, AuthState state) {
    if (state is AuthAuthenticated) {
      AppRoutes.navigateAfterAuth(context, state.user);
    } else if (state is AuthNeedsVerification) {
      Navigator.of(context).pushNamed(
        AppRoutes.otp,
        arguments: OtpRouteArgs(
          email: state.email,
          onVerify: (otp) async {
            // Access the registered VerifyEmailUseCase from getIt
            final verifyEmailUseCase = getIt<VerifyEmailUseCase>();
            await verifyEmailUseCase.call(email: state.email, otp: otp);
            if (context.mounted) {
              ScaffoldMessenger.of(context)
                ..clearSnackBars()
                ..showSnackBar(
                  const SnackBar(
                    content: Text('Email verified successfully. Please sign in.'),
                    backgroundColor: AppColors.brandPrimary500,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              Navigator.of(context).pushNamedAndRemoveUntil(
                AppRoutes.login,
                (route) => false,
              );
            }
          },
          onResend: () async {
            // Resend is not supported by API yet; stub cooldown delay
            await Future.delayed(const Duration(seconds: 1));
          },
        ),
      );
    } else if (state is AuthError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.message),
          backgroundColor: AppColors.error500,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}
