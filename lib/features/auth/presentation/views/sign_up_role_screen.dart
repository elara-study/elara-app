import 'package:elara/core/navigation/app_navigation.dart';
import 'package:elara/config/routes.dart';
import 'package:elara/core/enums/user_role.dart';
import 'package:elara/core/localization/localization_extension.dart';
import 'package:elara/features/auth/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SignUpRoleScreen extends StatefulWidget {
  final String? title;
  final bool showSocialAuth;

  const SignUpRoleScreen({
    super.key,
    this.title,
    this.showSocialAuth = true,
  });

  /// Named constructor used when reached from a social auth button —
  /// hides the social row since the user is already in that flow.
  const SignUpRoleScreen.social({super.key})
    : title = null,
      showSocialAuth = false;

  @override
  State<SignUpRoleScreen> createState() => _SignUpRoleScreenState();
}

class _SignUpRoleScreenState extends State<SignUpRoleScreen> {
  UserRole? _selectedRole;

  void _onRoleTap(UserRole role) {
    setState(() => _selectedRole = role);
    context.read<AuthCubit>().selectRole(role);

    // Check if we're in the Google complete-registration flow.
    final googleData =
        GoRouterState.of(context).extra as GooglePendingData?;

    Future.delayed(const Duration(milliseconds: 200), () {
      if (!mounted) return;
      AppNavigation.pushNamed(
        context,
        AppRoutes.signUpCredentials,
        arguments: googleData != null
            ? (role: role, googleData: googleData)
            : role,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final resolvedTitle = widget.title ?? context.l10n.authChooseRole;

    return Scaffold(
      body: AuthScreenLayout(
        // m comes from the full-page LayoutBuilder — correct dimensions.
        builder: (context, m) => _RoleCardContent(
          title: resolvedTitle,
          showSocialAuth: widget.showSocialAuth,
          selectedRole: _selectedRole,
          metrics: m,
          onRoleTap: _onRoleTap,
          onSocialTap: () =>
              AppNavigation.pushNamed(context, AppRoutes.signUpSocialRole),
        ),
      ),
    );
  }
}

// _RoleCardContent — the column inside the auth card.

class _RoleCardContent extends StatelessWidget {
  final String title;
  final bool showSocialAuth;
  final UserRole? selectedRole;
  final AuthScreenMetrics metrics;
  final ValueChanged<UserRole> onRoleTap;
  final VoidCallback onSocialTap;

  const _RoleCardContent({
    required this.title,
    required this.showSocialAuth,
    required this.selectedRole,
    required this.metrics,
    required this.onRoleTap,
    required this.onSocialTap,
  });

  @override
  Widget build(BuildContext context) {
    final m = metrics;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AuthCardHeader(
          title: title,
          subtitle: context.l10n.authChooseRoleSubtitle,
          isCompact: m.isCompact,
        ),
        SizedBox(height: m.sectionGap),

        // Role cards
        ...UserRole.values.map(
          (role) {
            final cardTitle = switch (role) {
              UserRole.student => context.l10n.authRoleStudent,
              UserRole.teacher => context.l10n.authRoleTeacher,
              UserRole.parent => context.l10n.authRoleParent,
            };
            final cardSubtitle = switch (role) {
              UserRole.student => context.l10n.authRoleStudentSubtitle,
              UserRole.teacher => context.l10n.authRoleTeacherSubtitle,
              UserRole.parent => context.l10n.authRoleParentSubtitle,
            };

            return Padding(
              padding: EdgeInsets.only(
                bottom: role == UserRole.values.last ? 0 : m.roleGap,
              ),
              child: RoleCard(
                role: role,
                title: cardTitle,
                subtitle: cardSubtitle,
                isSelected: selectedRole == role,
                height: m.roleCardHeight,
                contentPadding: m.roleCardContentPadding,
                iconSize: m.roleIconSize,
                onTap: () => onRoleTap(role),
              ),
            );
          },
        ),

        // ── Social auth (sign-up flow only) ─────────────────────────
        if (showSocialAuth) ...[
          SizedBox(height: m.sectionGap),
          AuthDivider(label: context.l10n.authOrSignUpWith),
          SizedBox(height: m.sectionGap),
          AuthSocialRow(
            gap: m.socialGap,
            shouldStack: m.shouldStackSocialButtons,
            onGoogleTap: () =>
                context.read<AuthCubit>().signInWithGoogle(),
            onFacebookTap: onSocialTap,
          ),
        ],

        SizedBox(height: m.sectionGap),
        AuthCardFooter(
          prompt: context.l10n.authAlreadyHaveAccount,
          actionLabel: context.l10n.authSignIn,
          onTap: () => AppNavigation.goNamed(context, AppRoutes.login),
        ),
      ],
    );
  }
}
