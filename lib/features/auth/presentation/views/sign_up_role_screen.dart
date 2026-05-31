import 'package:elara/config/routes.dart';
import 'package:elara/core/enums/user_role.dart';
import 'package:elara/features/auth/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpRoleScreen extends StatefulWidget {
  final String title;
  final bool showSocialAuth;

  const SignUpRoleScreen({
    super.key,
    this.title = 'Welcome to elara',
    this.showSocialAuth = true,
  });

  /// Named constructor used when reached from a social auth button —
  /// hides the social row since the user is already in that flow.
  const SignUpRoleScreen.social({super.key})
    : title = 'Choose your role',
      showSocialAuth = false;

  @override
  State<SignUpRoleScreen> createState() => _SignUpRoleScreenState();
}

class _SignUpRoleScreenState extends State<SignUpRoleScreen> {
  UserRole? _selectedRole;

  void _onRoleTap(UserRole role) {
    setState(() => _selectedRole = role);
    context.read<AuthCubit>().selectRole(role);
    Future.delayed(const Duration(milliseconds: 200), () {
      if (!mounted) return;
      Navigator.pushNamed(
        context,
        AppRoutes.signUpCredentials,
        arguments: role,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthScreenLayout(
        // m comes from the full-page LayoutBuilder — correct dimensions.
        builder: (context, m) => _RoleCardContent(
          title: widget.title,
          showSocialAuth: widget.showSocialAuth,
          selectedRole: _selectedRole,
          metrics: m,
          onRoleTap: _onRoleTap,
          onSocialTap: () =>
              Navigator.pushNamed(context, AppRoutes.signUpSocialRole),
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
          subtitle: 'Choose your role to start your journey',
          isCompact: m.isCompact,
        ),
        SizedBox(height: m.sectionGap),

        // Role cards
        ...UserRole.values.map(
          (role) => Padding(
            padding: EdgeInsets.only(
              bottom: role == UserRole.values.last ? 0 : m.roleGap,
            ),
            child: RoleCard(
              role: role,
              isSelected: selectedRole == role,
              height: m.roleCardHeight,
              contentPadding: m.roleCardContentPadding,
              iconSize: m.roleIconSize,
              onTap: () => onRoleTap(role),
            ),
          ),
        ),

        // ── Social auth (sign-up flow only) ─────────────────────────
        if (showSocialAuth) ...[
          SizedBox(height: m.sectionGap),
          const AuthDivider(label: 'OR SIGN UP WITH'),
          SizedBox(height: m.sectionGap),
          AuthSocialRow(
            gap: m.socialGap,
            shouldStack: m.shouldStackSocialButtons,
            onTap: onSocialTap,
          ),
        ],

        SizedBox(height: m.sectionGap),
        AuthCardFooter(
          prompt: 'Already have an account?',
          actionLabel: 'Sign in',
          onTap: () => Navigator.pushReplacementNamed(context, AppRoutes.login),
        ),
      ],
    );
  }
}
