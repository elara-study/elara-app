import 'package:elara/config/routes.dart';
import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/presentation/common/widgets/app_app_bar.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Teacher profile/settings screen (per Figma).
class TeacherProfileScreen extends StatelessWidget {
  const TeacherProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppBar.mainTab(
        title: 'teacher.profile'.tr,
        actions: AppAppBar.settingsAction(),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.spacing2xl),
        children: [
          ListTile(
            leading: const Icon(Icons.edit),
            title: Text('teacher.editProfile'.tr, style: AppTypography.bodyLarge()),
            trailing: const Icon(Icons.keyboard_arrow_right),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.lock),
            title: Text('teacher.changePassword'.tr, style: AppTypography.bodyLarge()),
            trailing: const Icon(Icons.keyboard_arrow_right),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.notifications_outlined),
            title: Text('teacher.notifications'.tr, style: AppTypography.bodyLarge()),
            trailing: const Icon(Icons.keyboard_arrow_right),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.help_outline),
            title: Text('teacher.helpCenter'.tr, style: AppTypography.bodyLarge()),
            trailing: const Icon(Icons.keyboard_arrow_right),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: Text('teacher.aboutUs'.tr, style: AppTypography.bodyLarge()),
            trailing: const Icon(Icons.keyboard_arrow_right),
            onTap: () {},
          ),
          const Divider(),
          ListTile(
            leading: Icon(Icons.logout, color: AppColors.error500),
            title: Text(
              'teacher.logout'.tr,
              style: AppTypography.bodyLarge(color: AppColors.error500),
            ),
            onTap: () => Navigator.of(
              context,
            ).pushReplacementNamed(AppRoutes.roleSelector),
          ),
        ],
      ),
    );
  }
}
