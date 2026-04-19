import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_radius.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:elara/core/theme/app_shadows.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class QuizResultsRewardCard extends StatelessWidget {
  const QuizResultsRewardCard({
    super.key,
    required this.xpEarned,
    required this.totalScoreXp,
    required this.level,
    required this.levelProgress,
    required this.streakDays,
  });

  final int xpEarned;
  final int totalScoreXp;
  final int level;
  final double levelProgress;
  final int streakDays;

  static final _xpFmt = NumberFormat.decimalPattern();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final secondary = isDark
        ? DarkModeColors.textSecondary
        : LightModeColors.textSecondary;
    final onSurface = theme.colorScheme.onSurface;
    final surface = isDark ? AppColors.neutral800 : theme.colorScheme.surface;

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
            'REWARD EARNED',
            style: AppTypography.labelRegular(color: secondary),
          ),
          const SizedBox(height: AppSpacing.spacingMd),
          Text(
            '+${_xpFmt.format(xpEarned)} XP',
            textAlign: TextAlign.center,
            style: AppTypography.h2(color: AppColors.brandPrimary500).copyWith(
              fontSize: 36,
              fontWeight: AppTypography.extraBold,
              height: 1.22,
            ),
          ),
          const SizedBox(height: AppSpacing.spacingMd),
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.spacingMd,
                vertical: AppSpacing.spacingSm,
              ),
              decoration: BoxDecoration(
                color: AppColors.brandSecondary500Alpha10,
                borderRadius: BorderRadius.circular(AppRadius.radiusFull),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.local_fire_department_rounded,
                    size: 16,
                    color: AppColors.brandSecondary500,
                  ),
                  const SizedBox(width: AppSpacing.spacingXs),
                  Text(
                    'STREAK: $streakDays DAYS',
                    style: AppTypography.labelRegular(
                      color: AppColors.brandSecondary500,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.spacingLg),
          Row(
            children: [
              Expanded(
                child: Text(
                  'TOTAL SCORE: ${_xpFmt.format(totalScoreXp)} XP',
                  style: AppTypography.labelRegular(color: onSurface),
                ),
              ),
              Text(
                'LEVEL $level',
                style: AppTypography.labelRegular(color: onSurface),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.spacingXs),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.radiusFull),
            child: SizedBox(
              height: 8,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ColoredBox(
                    color: AppColors.brandPrimary100.withValues(alpha: 0.5),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: FractionallySizedBox(
                      widthFactor: levelProgress.clamp(0.0, 1.0),
                      child: const ColoredBox(color: AppColors.brandPrimary700),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
