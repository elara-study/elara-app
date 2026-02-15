import 'package:elara/config/routes.dart';
import 'package:elara/presentation/common/widgets/app_app_bar.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:elara/presentation/common/widgets/app_buttons.dart';
import 'package:flutter/material.dart';

class QuizAttemptScreen extends StatelessWidget {
  const QuizAttemptScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppBar.detail(title: 'Quiz'),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.spacing2xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Question 1',
                style: AppTypography.h5(),
              ),
              const SizedBox(height: AppSpacing.spacingLg),
              Text(
                'Sample question text goes here. (MCQ or written answer)',
                style: AppTypography.bodyLarge(),
              ),
              const SizedBox(height: AppSpacing.spacing2xl),
              const TextField(
                decoration: InputDecoration(
                  hintText: 'Your answer',
                ),
                maxLines: 4,
              ),
              const Spacer(),
              AppPrimaryButton(
                text: 'Submit Quiz',
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
