import 'package:elara/config/routes.dart';
import 'package:elara/presentation/common/widgets/app_app_bar.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:elara/presentation/common/widgets/app_buttons.dart';
import 'package:flutter/material.dart';

class QuizResultsScreen extends StatelessWidget {
  const QuizResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppBar.detail(title: 'Quiz Results'),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.spacing2xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Your score: 85%',
                style: AppTypography.h3(),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.spacingLg),
              Text(
                'AI feedback and identified gaps will appear here.',
                style: AppTypography.bodyMedium(),
              ),
              const Spacer(),
              AppPrimaryButton(
                text: 'Back to Class',
                onPressed: () => Navigator.of(context).popUntil(
                  (route) => route.settings.name == AppRoutes.student || route.isFirst,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
