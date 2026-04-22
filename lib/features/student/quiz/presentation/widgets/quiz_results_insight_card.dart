import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_radius.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:flutter/material.dart';

class QuizResultsInsightCard extends StatelessWidget {
  const QuizResultsInsightCard({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final secondary = isDark
        ? DarkModeColors.textSecondary
        : LightModeColors.textSecondary;
    final fill = AppColors.brandPrimary500Alpha10;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.spacing2xl),
      decoration: BoxDecoration(
        color: fill,
        borderRadius: BorderRadius.circular(AppRadius.radiusLg),
        border: const Border(
          left: BorderSide(color: AppColors.brandPrimary500, width: 3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Icon(
                Icons.lightbulb,
                size: 20,
                color: AppColors.brandPrimary500,
              ),
              const SizedBox(width: AppSpacing.spacingXs),
              Text(
                'ELARA INSIGHT',
                style: AppTypography.h6(
                  color: AppColors.brandPrimary500,
                ).copyWith(fontWeight: AppTypography.extraBold),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.spacingXs),
          Text(
            message,
            textAlign: TextAlign.start,
            style: AppTypography.bodyMedium(color: secondary),
          ),
        ],
      ),
    );
  }
}
