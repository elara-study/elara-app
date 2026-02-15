import 'package:elara/config/routes.dart';
import 'package:elara/domain/models/user.dart';
import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:elara/presentation/common/widgets/app_buttons.dart';
import 'package:flutter/material.dart';

/// Sign up - Role selection: Teacher, Student, Parent (per Figma).
class SignUpRoleScreen extends StatelessWidget {
  const SignUpRoleScreen({super.key});

  void _selectRole(BuildContext context, UserRole role) {
    final route = role == UserRole.teacher
        ? AppRoutes.teacher
        : role == UserRole.student
            ? AppRoutes.student
            : AppRoutes.parent;
    Navigator.of(context).pushNamedAndRemoveUntil(route, (_) => false);
  }

  void _onSignIn(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil(
      AppRoutes.login,
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutral50,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.spacing2xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Sign up to start your study journey',
                style: AppTypography.h3(color: AppColors.neutral900),
              ),
              const SizedBox(height: AppSpacing.spacingSm),
              Text(
                'Choose your role',
                style: AppTypography.bodyLarge(color: AppColors.neutral600),
              ),
              const SizedBox(height: AppSpacing.spacing3xl),
              AppPrimaryButton(
                text: 'Teacher',
                icon: Icons.school,
                onPressed: () => _selectRole(context, UserRole.teacher),
              ),
              const SizedBox(height: AppSpacing.spacingLg),
              AppSecondaryButton(
                text: 'Student',
                icon: Icons.person,
                onPressed: () => _selectRole(context, UserRole.student),
              ),
              const SizedBox(height: AppSpacing.spacingLg),
              AppOutlineButton(
                text: 'Parent',
                icon: Icons.family_restroom,
                onPressed: () => _selectRole(context, UserRole.parent),
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account?',
                    style: AppTypography.labelSmall(color: AppColors.neutral900),
                  ),
                  const SizedBox(width: AppSpacing.spacingXs),
                  TextButton(
                    onPressed: () => _onSignIn(context),
                    child: Text(
                      'Sign in',
                      style: AppTypography.labelSmall(
                        color: AppColors.brandPrimary500,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
