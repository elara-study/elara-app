import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:flutter/material.dart';

class QuizResultsHero extends StatelessWidget {
  const QuizResultsHero({super.key, required this.celebrationSubtitle});

  final String celebrationSubtitle;

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;
    final secondary = Theme.of(context).brightness == Brightness.dark
        ? DarkModeColors.textSecondary
        : LightModeColors.textSecondary;

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.brandPrimary500Alpha20,
          ),
          child: const Icon(
            Icons.emoji_events_rounded,
            size: 24,
            color: AppColors.brandPrimary500,
          ),
        ),
        const SizedBox(height: AppSpacing.spacingLg),
        Text(
          'Quiz Complete!',
          textAlign: TextAlign.center,
          style: AppTypography.h2(
            color: onSurface,
          ).copyWith(fontWeight: AppTypography.black, height: 1.29),
        ),
        const SizedBox(height: AppSpacing.spacingXs),
        Text(
          celebrationSubtitle,
          textAlign: TextAlign.center,
          style: AppTypography.bodyMedium(color: secondary),
        ),
      ],
    );
  }
}
