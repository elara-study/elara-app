import 'package:elara/config/routes.dart';
import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_radius.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:elara/features/auth/auth.dart';
import 'package:elara/shared/widgets/app_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: _onAuthStateChange,
        builder: (context, state) => AuthScreenLayout(
          builder: (context, m) =>
              _SignInCardContent(isLoading: state is AuthLoading, metrics: m),
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
// _SignInCardContent — stateful form inside the auth card.

class _SignInCardContent extends StatefulWidget {
  final bool isLoading;
  final AuthScreenMetrics metrics;
  const _SignInCardContent({required this.isLoading, required this.metrics});

  @override
  State<_SignInCardContent> createState() => _SignInCardContentState();
}

class _SignInCardContentState extends State<_SignInCardContent> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthCubit>().signIn(
        email: _emailCtrl.text.trim(),
        password: _passwordCtrl.text,
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
            title: 'Welcome back',
            subtitle: 'Enter your details to sign in',
            isCompact: m.isCompact,
          ),
          SizedBox(height: m.sectionGap),

          // Email / Username
          AuthCardField(
            label: 'Email or Username',
            hint: 'Enter your email or username',
            controller: _emailCtrl,
            keyboardType: TextInputType.emailAddress,
            validator: (v) => (v == null || v.isEmpty)
                ? 'Email or username is required'
                : null,
          ),
          SizedBox(height: m.fieldGap),

          // Password
          AuthCardField(
            label: 'Password',
            hint: 'Enter your password',
            controller: _passwordCtrl,
            isPassword: true,
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => _submit(),
            validator: (v) =>
                (v == null || v.isEmpty) ? 'Password is required' : null,
          ),
          const SizedBox(height: AppSpacing.spacingXs),
          // Forgot password
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () =>
                  Navigator.pushNamed(context, AppRoutes.forgotPassword),
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                'Forgot password?',
                style: AppTypography.labelSmall(color: ButtonColors.ghostText),
              ),
            ),
          ),

          SizedBox(height: m.sectionGap),

          // Login button
          SizedBox(
            width: double.infinity,
            child: AppPrimaryButton(
              text: 'Login',
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

          // Social auth
          const AuthDivider(label: 'OR LOGIN WITH'),
          SizedBox(height: m.sectionGap),
          AuthSocialRow(
            gap: m.socialGap,
            shouldStack: m.shouldStackSocialButtons,
            onTap: () =>
                Navigator.pushNamed(context, AppRoutes.signUpSocialRole),
          ),

          SizedBox(height: m.sectionGap),

          // Footer
          AuthCardFooter(
            prompt: "Don't have an account?",
            actionLabel: 'Sign up',
            onTap: () => Navigator.pushNamed(context, AppRoutes.signUpRole),
          ),
        ],
      ),
    );
  }
}
