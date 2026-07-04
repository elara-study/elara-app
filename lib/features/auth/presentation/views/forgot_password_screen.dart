import 'package:elara/core/navigation/app_navigation.dart';
import 'package:elara/config/routes.dart';
import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_radius.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/core/localization/localization_extension.dart';
import 'package:elara/features/auth/auth.dart';
import 'package:elara/shared/widgets/app_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: _onAuthStateChange,
        builder: (context, state) => AuthScreenLayout(
          builder: (context, m) => _ForgotPasswordCardContent(
            isLoading: state is AuthLoading,
            metrics: m,
          ),
        ),
      ),
    );
  }

  static void _onAuthStateChange(BuildContext context, AuthState state) {
    if (state is ForgotPasswordOtpSent) {
      // Navigate to OTP screen — reuse the same OtpScreen with reset-flow args.
      AppNavigation.pushNamed(
        context,
        AppRoutes.otp,
        arguments: OtpRouteArgs(
          email: state.email,
          onVerify: (otp) async {
            if (context.mounted) {
              AppNavigation.pushReplacementNamed(
                context,
                AppRoutes.resetPassword,
                arguments: ResetPasswordRouteArgs(
                  email: state.email,
                  otp: otp,
                ),
              );
            }
          },
          onResend: () async {
            // Re-send forgot-password OTP.
            context.read<AuthCubit>().forgotPassword(email: state.email);
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

// _ForgotPasswordCardContent — stateful form inside the auth card.

class _ForgotPasswordCardContent extends StatefulWidget {
  final bool isLoading;
  final AuthScreenMetrics metrics;
  const _ForgotPasswordCardContent({
    required this.isLoading,
    required this.metrics,
  });

  @override
  State<_ForgotPasswordCardContent> createState() =>
      _ForgotPasswordCardContentState();
}

class _ForgotPasswordCardContentState
    extends State<_ForgotPasswordCardContent> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();

  @override
  void dispose() {
    _emailCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    context.read<AuthCubit>().forgotPassword(
      email: _emailCtrl.text.trim(),
    );
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
            title: context.l10n.authForgotPasswordTitle,
            subtitle: context.l10n.authForgotPasswordSubtitle,
            isCompact: m.isCompact,
          ),
          SizedBox(height: m.sectionGap),

          // Email field
          AuthCardField(
            label: context.l10n.authEmail,
            hint: context.l10n.authEmailHint,
            controller: _emailCtrl,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => _submit(),
            validator: (v) {
              if (v == null || v.isEmpty) return context.l10n.authEmailRequired;
              final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
              if (!emailRegex.hasMatch(v)) return context.l10n.authEmailInvalid;
              return null;
            },
          ),

          SizedBox(height: m.sectionGap),

          // Send reset code button
          SizedBox(
            width: double.infinity,
            child: AppPrimaryButton(
              text: context.l10n.authSendResetLink,
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
            prompt: context.l10n.authRememberPassword,
            actionLabel: context.l10n.authSignIn,
            onTap: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}
