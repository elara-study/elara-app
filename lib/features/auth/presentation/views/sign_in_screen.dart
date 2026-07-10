import 'package:elara/core/navigation/app_navigation.dart';
import 'package:elara/config/routes.dart';
import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_radius.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/core/theme/app_typography.dart';
 import 'package:elara/core/localization/localization_extension.dart';
 import 'package:elara/core/utils/app_snackbar.dart';
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
        listenWhen: (previous, current) {
          if (current is AuthNeedsVerification) {
            return previous is! AuthNeedsVerification;
          }
          return current is GoogleSignInNeedsRole || current is AuthError;
        },
        listener: _onAuthStateChange,
        builder: (context, state) => AuthScreenLayout(
          builder: (context, m) =>
              _SignInCardContent(
                isLoading: state is AuthLoading,
                isGoogleLoading: state is AuthGoogleLoading,
                metrics: m,
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
    } else if (state is GoogleSignInNeedsRole) {
      AppNavigation.pushNamed(
        context,
        AppRoutes.signUpSocialRole,
        arguments: GooglePendingData(
          pendingToken: state.pendingToken,
          refreshToken: state.refreshToken,
        ),
      );
    } else if (state is AuthError) {
      AppSnackBar.error(context, state.message);
    }
  }
}
// _SignInCardContent — stateful form inside the auth card.

class _SignInCardContent extends StatefulWidget {
  final bool isLoading;
  final bool isGoogleLoading;
  final AuthScreenMetrics metrics;
  const _SignInCardContent({
    required this.isLoading,
    required this.isGoogleLoading,
    required this.metrics,
  });

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
            title: context.l10n.authWelcomeBack,
            subtitle: context.l10n.authSignInSubtitle,
            isCompact: m.isCompact,
          ),
          SizedBox(height: m.sectionGap),

          // Email / Username
          AuthCardField(
            label: context.l10n.authEmailOrUsername,
            hint: context.l10n.authEmailOrUsernameHint,
            controller: _emailCtrl,
            keyboardType: TextInputType.emailAddress,
            validator: (v) => (v == null || v.isEmpty)
                ? context.l10n.authEmailOrUsernameRequired
                : null,
          ),
          SizedBox(height: m.fieldGap),

          // Password
          AuthCardField(
            label: context.l10n.authPassword,
            hint: context.l10n.authPasswordHint,
            controller: _passwordCtrl,
            isPassword: true,
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => _submit(),
            validator: (v) =>
                (v == null || v.isEmpty) ? context.l10n.authPasswordRequired : null,
          ),
          const SizedBox(height: AppSpacing.spacingXs),
          // Forgot password
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () =>
                  AppNavigation.pushNamed(context, AppRoutes.forgotPassword),
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                context.l10n.authForgotPassword,
                style: AppTypography.labelSmall(color: ButtonColors.ghostText),
              ),
            ),
          ),

          SizedBox(height: m.sectionGap),

          // Login button
          SizedBox(
            width: double.infinity,
            child: AppPrimaryButton(
              text: context.l10n.authLoginButton,
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
          AuthDivider(label: context.l10n.authOrLoginWith),
          SizedBox(height: m.sectionGap),
          AuthSocialRow(
            gap: m.socialGap,
            shouldStack: m.shouldStackSocialButtons,
            onGoogleTap: () =>
                context.read<AuthCubit>().signInWithGoogle(),
            onFacebookTap: () =>
                AppNavigation.pushNamed(context, AppRoutes.signUpSocialRole),
            isGoogleLoading: widget.isGoogleLoading,
          ),

          SizedBox(height: m.sectionGap),

          // Footer
          AuthCardFooter(
            prompt: context.l10n.authDontHaveAccount,
            actionLabel: context.l10n.authSignUp,
            onTap: () => AppNavigation.pushNamed(context, AppRoutes.signUpRole),
          ),
        ],
      ),
    );
  }
}
