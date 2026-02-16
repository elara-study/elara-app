import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/presentation/common/widgets/app_app_bar.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:elara/presentation/common/widgets/app_buttons.dart';
import 'package:flutter/material.dart';

/// Screen for setting custom grading criteria for written questions.
/// AI will grade student answers against these criteria and identify gaps.
class QuizCriteriaScreen extends StatelessWidget {
  const QuizCriteriaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppBar.detail(title: 'Quiz Grading Criteria', showBackButton: false),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.spacing2xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Written Question Criteria', style: AppTypography.h5()),
              const SizedBox(height: AppSpacing.spacingSm),
              Text(
                'Define criteria for AI to grade written answers and identify gaps.',
                style: AppTypography.bodyMedium(),
              ),
              const SizedBox(height: AppSpacing.spacing2xl),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Grading criteria',
                  hintText:
                      'e.g. Must mention X, structure: intro-body-conclusion',
                ),
                maxLines: 5,
              ),
              const Spacer(),
              AppPrimaryButton(
                text: 'Save & Create Quiz',
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
