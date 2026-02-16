import 'package:elara/config/routes.dart';
import 'package:elara/presentation/common/widgets/app_app_bar.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:elara/presentation/common/widgets/app_buttons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class QuizAttemptScreen extends StatelessWidget {
  const QuizAttemptScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppBar.detail(title: 'student.quiz'.tr, showBackButton: false),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.spacing2xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                '${'student.questionLabel'.tr} 1',
                style: AppTypography.h5(),
              ),
              const SizedBox(height: AppSpacing.spacingLg),
              Text(
                'student.sampleQuestion'.tr,
                style: AppTypography.bodyLarge(),
              ),
              const SizedBox(height: AppSpacing.spacing2xl),
              TextField(
                decoration: InputDecoration(
                  hintText: 'student.yourAnswer'.tr,
                ),
                maxLines: 4,
              ),
              const Spacer(),
              AppPrimaryButton(
                text: 'student.submitQuiz'.tr,
                onPressed: () =>
                    Navigator.of(context).pushReplacementNamed(AppRoutes.studentQuizResults),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
