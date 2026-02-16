import 'package:elara/config/routes.dart';
import 'package:elara/core/localization/locale_controller.dart';
import 'package:elara/domain/models/user.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:elara/presentation/common/widgets/app_buttons.dart';
import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Mock role selector for prototype - no auth.
/// User picks a role to enter the app.
class RoleSelectorScreen extends StatelessWidget {
  const RoleSelectorScreen({super.key});

  void _selectRole(BuildContext context, UserRole role) {
    if (role == UserRole.teacher) {
      Navigator.of(context).pushReplacementNamed(AppRoutes.teacher);
    } else {
      Navigator.of(context).pushReplacementNamed(AppRoutes.student);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutral50,
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.spacing5xl,
            vertical: AppSpacing.spacing6xl,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: SvgPicture.asset(
                  'assets/logo/logo.svg',
                  width: 164,
                  height: 97,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: AppSpacing.spacing3xl),
              Text(
                'auth.createAccount'.tr,
                style: AppTypography.h2(color: AppColors.neutral900),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.spacingMd),
              Text(
                'auth.signUpSubtitle'.tr,
                style: AppTypography.bodyLarge(color: AppColors.neutral600),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.spacing5xl),
              AppGradientButton(
                text: 'auth.student'.tr,
                secondaryText: 'auth.joinAsStudent'.tr,
                icon: Icons.school_outlined,
                iconColor: AppColors.primary500,
                onPressed: () => _selectRole(context, UserRole.student),
              ),
              const SizedBox(height: AppSpacing.spacingLg),
              AppGradientButton(
                text: 'auth.teacher'.tr,
                gradient: AppGradients.secondary,
                secondaryText: 'auth.joinAsTeacher'.tr,
                iconColor: AppColors.secondary500,
                icon: Icons.person_2_outlined,
                onPressed: () => _selectRole(context, UserRole.teacher),
              ),
              const SizedBox(height: AppSpacing.spacing4xl),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'auth.alreadyHaveAccount'.tr,
                    style: AppTypography.labelSmall(),
                  ),
                  TextButton(
                    onPressed: () =>
                        Navigator.of(context).pushNamed(AppRoutes.login),
                    child: Text(
                      'auth.signIn'.tr,
                      style: AppTypography.labelMedium(
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
          Positioned(
            top: 0,
            right: 0,
            child: SafeArea(
              bottom: false,
              child: Obx(() {
                final c = Get.find<LocaleController>();
                return IconButton(
                  icon: Text(
                    c.isArabic ? 'EN' : 'ع',
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  tooltip: c.isArabic ? 'Switch to English' : 'التبديل إلى العربية',
                  onPressed: () => c.toggleLocale(),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
