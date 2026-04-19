import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_radius.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:elara/core/theme/app_shadows.dart';
import 'package:flutter/material.dart';

/// Results hero card: headline score and correct count (same card language as [QuizQuestionCard]).
class QuizScoreSummaryCard extends StatelessWidget {
  const QuizScoreSummaryCard({
    super.key,
    required this.scorePercentLabel,
    required this.correctLabel,
    this.caption = 'Keep practicing to improve your streak.',
  });

  final String scorePercentLabel;
  final String correctLabel;
  final String caption;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;
    final secondary = theme.brightness == Brightness.dark
        ? DarkModeColors.textSecondary
        : LightModeColors.textSecondary;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.spacing2xl),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.radiusLg),
        boxShadow: AppShadows.elevation(theme.brightness),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.emoji_events_rounded,
            size: 48,
            color: AppColors.brandSecondary500,
          ),
          const SizedBox(height: AppSpacing.spacingLg),
          Text(
            'Quiz complete',
            style: AppTypography.h6(color: onSurface),
          ),
          const SizedBox(height: AppSpacing.spacingSm),
          Text(
            scorePercentLabel,
            style: AppTypography.h1(color: AppColors.brandPrimary500),
          ),
          const SizedBox(height: AppSpacing.spacingXs),
          Text(
            correctLabel,
            style: AppTypography.bodyLarge(color: onSurface),
          ),
          const SizedBox(height: AppSpacing.spacingMd),
          Text(
            caption,
            textAlign: TextAlign.center,
            style: AppTypography.bodyMedium(color: secondary),
          ),
        ],
      ),
    );
  }
}
