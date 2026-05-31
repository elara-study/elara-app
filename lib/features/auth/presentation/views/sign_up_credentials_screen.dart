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
            onSubmit: ({required fullName, required email, required password}) {
              context.read<AuthCubit>().signUp(
                fullName: fullName,
                email: email,
                password: password,
                role: role,
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
