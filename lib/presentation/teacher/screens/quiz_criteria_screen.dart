import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/presentation/common/widgets/app_app_bar.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:elara/presentation/common/widgets/app_buttons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Screen for setting custom grading criteria for written questions.
/// AI will grade student answers against these criteria and identify gaps.
class QuizCriteriaScreen extends StatelessWidget {
  const QuizCriteriaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppBar.detail(title: 'teacher.quizGradingCriteria'.tr, showBackButton: false),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.spacing2xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('teacher.writtenQuestionCriteria'.tr, style: AppTypography.h5()),
              const SizedBox(height: AppSpacing.spacingSm),
              Text(
                'teacher.defineCriteriaHint'.tr,
                style: AppTypography.bodyMedium(),
              ),
              const SizedBox(height: AppSpacing.spacing2xl),
              TextField(
                decoration: InputDecoration(
                  labelText: 'teacher.gradingCriteriaLabel'.tr,
                  hintText: 'teacher.gradingCriteriaHint'.tr,
                ),
                maxLines: 5,
              ),
              const Spacer(),
              AppPrimaryButton(
                text: 'teacher.saveCreateQuiz'.tr,
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
