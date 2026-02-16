import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/presentation/common/widgets/app_app_bar.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:elara/presentation/common/widgets/app_buttons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class JoinClassScreen extends StatelessWidget {
  const JoinClassScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppBar.detail(title: 'student.joinClass'.tr, showBackButton: false),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.spacing2xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'student.enterClassCode'.tr,
                style: AppTypography.bodyLarge(),
              ),
              const SizedBox(height: AppSpacing.spacingLg),
              TextField(
                decoration: InputDecoration(
                  labelText: 'student.classCode'.tr,
                  hintText: 'student.classCodeHint'.tr,
                ),
              ),
              const SizedBox(height: AppSpacing.spacing2xl),
              AppPrimaryButton(
                text: 'student.joinClass'.tr,
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
