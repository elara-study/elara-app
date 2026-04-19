import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_radius.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:elara/core/theme/app_shadows.dart';
import 'package:flutter/material.dart';

/// ACCURACY card: donut + correct / unanswered / wrong counts.
class QuizResultsAccuracyCard extends StatelessWidget {
  const QuizResultsAccuracyCard({
    super.key,
    required this.accuracyPercent,
    required this.correctCount,
    required this.unansweredCount,
    required this.wrongCount,
  });

  final int accuracyPercent;
  final int correctCount;
  final int unansweredCount;
  final int wrongCount;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final secondary = isDark
        ? DarkModeColors.textSecondary
        : LightModeColors.textSecondary;
    final onSurface = theme.colorScheme.onSurface;
    final surface = isDark ? AppColors.neutral800 : theme.colorScheme.surface;
    final t = accuracyPercent.clamp(0, 100) / 100.0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.spacing2xl),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(AppRadius.radiusLg),
        boxShadow: AppShadows.elevation(theme.brightness),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'ACCURACY',
            style: AppTypography.labelRegular(color: secondary),
          ),
          const SizedBox(height: AppSpacing.spacingLg),
          Center(
            child: SizedBox(
              width: 96,
              height: 96,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox.expand(
                    child: CircularProgressIndicator(
                      value: t,
                      strokeWidth: 8,
                      backgroundColor:
                          AppColors.brandPrimary100.withValues(alpha: 0.5),
                      color: AppColors.brandPrimary700,
                    ),
                  ),
                  Text(
                    '$accuracyPercent%',
                    style: AppTypography.h3(color: onSurface).copyWith(
                          fontWeight: AppTypography.black,
                        ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.spacingLg),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _AccuracyStat(
                value: '$correctCount',
                label: 'CORRECT',
                valueColor: AppColors.success500,
              ),
              _AccuracyStat(
                value: '$unansweredCount',
                label: 'UNANSWERED',
                valueColor: AppColors.warning500,
              ),
              _AccuracyStat(
                value: '$wrongCount',
                label: 'WRONG',
                valueColor: AppColors.error500,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AccuracyStat extends StatelessWidget {
  const _AccuracyStat({
    required this.value,
    required this.label,
    required this.valueColor,
  });

  final String value;
  final String label;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    final secondary = Theme.of(context).brightness == Brightness.dark
        ? DarkModeColors.textSecondary
        : LightModeColors.textSecondary;

    return Column(
      children: [
        Text(
          value,
          style: AppTypography.labelRegular(color: valueColor).copyWith(
                fontSize: 14,
                fontWeight: AppTypography.semiBold,
              ),
        ),
        const SizedBox(height: AppSpacing.spacing2xs),
        Text(
          label,
          style: AppTypography.labelSmall(color: secondary).copyWith(
                fontSize: 10,
                fontWeight: AppTypography.semiBold,
                letterSpacing: 0.2,
              ),
        ),
      ],
    );
  }
}
