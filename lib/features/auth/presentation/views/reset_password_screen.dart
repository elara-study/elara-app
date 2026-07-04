import 'package:elara/core/navigation/app_navigation.dart';
import 'package:elara/config/routes.dart';
import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_radius.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/core/utils/app_snackbar.dart';
import 'package:elara/features/auth/auth.dart';
import 'package:elara/shared/widgets/app_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

/// Route arguments for [ResetPasswordScreen].
class ResetPasswordRouteArgs {
  final String email;
  final String otp;

  const ResetPasswordRouteArgs({required this.email, required this.otp});
}

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = GoRouterState.of(context).extra! as ResetPasswordRouteArgs;

    return Scaffold(
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: _onAuthStateChange,
        builder: (context, state) => AuthScreenLayout(
          builder: (context, m) => _ResetPasswordCardContent(
            email: args.email,
            otp: args.otp,
            isLoading: state is AuthLoading,
            metrics: m,
          ),
        ),
      ),
    );
  }

  static void _onAuthStateChange(BuildContext context, AuthState state) {
    if (state is PasswordResetSuccess) {
      AppSnackBar.success(context, 'Password reset successfully. Please sign in.');
      AppNavigation.pushNamedAndRemoveUntil(context, AppRoutes.login);
    } else if (state is AuthError) {
      AppSnackBar.error(context, state.message);
    }
  }
}

// _ResetPasswordCardContent — stateful form inside the auth card.

class _ResetPasswordCardContent extends StatefulWidget {
  final String email;
  final String otp;
  final bool isLoading;
  final AuthScreenMetrics metrics;

  const _ResetPasswordCardContent({
    required this.email,
    required this.otp,
    required this.isLoading,
    required this.metrics,
  });

  @override
  State<_ResetPasswordCardContent> createState() =>
      _ResetPasswordCardContentState();
}

class _ResetPasswordCardContentState
    extends State<_ResetPasswordCardContent> {
  final _formKey = GlobalKey<FormState>();
  final _passwordCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  @override
  void dispose() {
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthCubit>().resetPassword(
        email: widget.email,
        otp: widget.otp,
        newPassword: _passwordCtrl.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final m = widget.metrics;

    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          AuthCardHeader(
            title: 'Reset password',
            subtitle: 'Enter your new password below',
            isCompact: m.isCompact,
          ),
          SizedBox(height: m.sectionGap),

          // New Password
          AuthCardField(
            label: 'New Password',
            hint: 'Enter your new password',
            controller: _passwordCtrl,
            isPassword: true,
            validator: (v) {
              if (v == null || v.isEmpty) return 'Password is required';
              if (v.length < 6) return 'Minimum 6 characters';
              return null;
            },
          ),
          SizedBox(height: m.fieldGap),

          // Confirm Password
          AuthCardField(
            label: 'Confirm Password',
            hint: 'Re-enter your password',
            controller: _confirmCtrl,
            isPassword: true,
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => _submit(),
            validator: (v) {
              if (v == null || v.isEmpty) return 'Please confirm your password';
              if (v != _passwordCtrl.text) return 'Passwords do not match';
              return null;
            },
          ),

          SizedBox(height: m.sectionGap),

          // Reset button
          SizedBox(
            width: double.infinity,
            child: AppPrimaryButton(
              text: 'Reset Password',
              isLoading: widget.isLoading,
              onPressed: _submit,
              leading: SvgPicture.asset(
                'assets/icons/join_icon.svg',
                colorFilter: const ColorFilter.mode(
                  ButtonColors.primaryText,
                  BlendMode.srcIn,
                ),
              ),
              borderRadius: BorderRadius.circular(AppRadius.radiusFull),
              padding: const EdgeInsets.symmetric(
                vertical: AppSpacing.spacingSm,
              ),
            ),
          ),

          SizedBox(height: m.sectionGap),

          // Footer — back to sign in
          AuthCardFooter(
            prompt: 'Remember your password?',
            actionLabel: 'Sign in',
            onTap: () =>
                AppNavigation.pushNamedAndRemoveUntil(context, AppRoutes.login),
          ),
        ],
      ),
    );
  }
}
