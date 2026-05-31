import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_radius.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:elara/features/auth/auth.dart';
import 'package:elara/shared/widgets/app_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthScreenLayout(
        builder: (context, m) => _ForgotPasswordCardContent(metrics: m),
      ),
    );
  }
}

// _ForgotPasswordCardContent — stateful form inside the auth card.

class _ForgotPasswordCardContent extends StatefulWidget {
  final AuthScreenMetrics metrics;
  const _ForgotPasswordCardContent({required this.metrics});

  @override
  State<_ForgotPasswordCardContent> createState() =>
      _ForgotPasswordCardContentState();
}

class _ForgotPasswordCardContentState
    extends State<_ForgotPasswordCardContent> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  bool _isLoading = false;
  bool _emailSent = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    // TODO: wire to AuthCubit.sendPasswordResetEmail()
    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;
    setState(() {
      _isLoading = false;
      _emailSent = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final m = widget.metrics;

    if (_emailSent) {
      return _SuccessContent(
        email: _emailCtrl.text.trim(),
        metrics: m,
        onBack: () => Navigator.of(context).pop(),
      );
    }

    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          AuthCardHeader(
            title: 'Forgot password?',
            subtitle: "Enter your email and we'll send you a reset link",
            isCompact: m.isCompact,
          ),
          SizedBox(height: m.sectionGap),

          // Email field
          AuthCardField(
            label: 'Email',
            hint: 'Enter your email address',
            controller: _emailCtrl,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => _submit(),
            validator: (v) {
              if (v == null || v.isEmpty) return 'Email is required';
              final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
              if (!emailRegex.hasMatch(v)) return 'Enter a valid email address';
              return null;
            },
          ),

          SizedBox(height: m.sectionGap),

          // Send reset link button
          SizedBox(
            width: double.infinity,
            child: AppPrimaryButton(
              text: 'Send reset link',
              isLoading: _isLoading,
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
            onTap: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}

// _SuccessContent — shown after the reset email has been dispatched.

class _SuccessContent extends StatelessWidget {
  final String email;
  final AuthScreenMetrics metrics;
  final VoidCallback onBack;

  const _SuccessContent({
    required this.email,
    required this.metrics,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final m = metrics;
    final cs = Theme.of(context).colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Icon badge
        Center(
          child: Container(
            width: 72,
            height: 72,
            decoration: const BoxDecoration(
              color: AppColors.brandPrimary100,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.mark_email_read_outlined,
              color: AppColors.brandPrimary500,
              size: 36,
            ),
          ),
        ),
        SizedBox(height: m.sectionGap),

        AuthCardHeader(
          title: 'Check your inbox',
          subtitle:
              'We sent a password reset link to\n${email.isNotEmpty ? email : 'your email'}',
          isCompact: m.isCompact,
        ),
        SizedBox(height: m.sectionGap),

        // Back to sign in button
        SizedBox(
          width: double.infinity,
          child: AppPrimaryButton(
            text: 'Back to sign in',
            isLoading: false,
            onPressed: onBack,
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

        // Resend hint
        Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: AppSpacing.spacingXs,
          children: [
            Text(
              "Didn't receive the email?",
              style: AppTypography.labelSmall(color: cs.onSurface),
            ),
            TextButton(
              onPressed: onBack,
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                minimumSize: const Size(54, 24),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                'Resend',
                style: AppTypography.labelSmall(color: ButtonColors.ghostText),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
