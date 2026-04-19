import 'package:elara/config/routes.dart';
import 'package:elara/core/enums/user_role.dart';
import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:elara/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:elara/features/auth/presentation/cubits/auth_state.dart';
import 'package:elara/features/auth/presentation/widgets/auth_primary_button.dart';
import 'package:elara/features/auth/presentation/widgets/auth_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SignUpCredentialsScreen extends StatelessWidget {
  const SignUpCredentialsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final role = ModalRoute.of(context)!.settings.arguments as UserRole;
    final fullNameCtrl = TextEditingController();
    final emailCtrl = TextEditingController();
    final passwordCtrl = TextEditingController();
    final confirmPasswordCtrl = TextEditingController();
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      backgroundColor: AppColors.brandPrimary100,
      appBar: AppBar(
        backgroundColor: AppColors.brandPrimary100,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: LightModeColors.textPrimary,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Credentials',
          style: AppTypography.h4(
            color: LightModeColors.textPrimary,
          ).copyWith(fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
      ),
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
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
        },
        builder: (context, state) {
          final isLoading = state is AuthLoading;

          return SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 54.h),

                    Text(
                      'Enter your credentials',
                      style: AppTypography.h2(
                        color: LightModeColors.textPrimary,
                      ),
                    ),

                    SizedBox(height: 36.h),

                    AuthTextField(
                      label: 'Full Name',
                      hint: 'Enter your full name',
                      controller: fullNameCtrl,
                      textInputAction: TextInputAction.next,
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) {
                          return 'Full name is required';
                        }
                        if (val.trim().length < 3) {
                          return 'Name must be at least 3 characters';
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: 8.h),

                    AuthTextField(
                      label: 'Email',
                      hint: 'Enter an email address',
                      controller: emailCtrl,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return 'Email is required';
                        }
                        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(val)) {
                          return 'Enter a valid email';
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: 8.h),

                    AuthTextField(
                      label: 'Password',
                      hint: 'Enter a new password',
                      controller: passwordCtrl,
                      isPassword: true,
                      textInputAction: TextInputAction.next,
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return 'Password is required';
                        }
                        if (val.length < 8) {
                          return 'Password must be at least 8 characters';
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: 8.h),

                    AuthTextField(
                      label: 'Confirm Password',
                      hint: 'Confirm your new password',
                      controller: confirmPasswordCtrl,
                      isPassword: true,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) {
                        if (formKey.currentState!.validate()) {
                          context.read<AuthCubit>().signUp(
                            fullName: fullNameCtrl.text.trim(),
                            email: emailCtrl.text.trim(),
                            password: passwordCtrl.text,
                            role: role,
                          );
                        }
                      },
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return 'Please confirm your password';
                        }
                        if (val != passwordCtrl.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: 16.h),

                    AuthPrimaryButton(
                      label: 'Sign up',
                      icon: Icons.login_rounded,
                      isLoading: isLoading,
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          context.read<AuthCubit>().signUp(
                            fullName: fullNameCtrl.text.trim(),
                            email: emailCtrl.text.trim(),
                            password: passwordCtrl.text,
                            role: role,
                          );
                        }
                      },
                    ),

                    SizedBox(height: 16.h),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
