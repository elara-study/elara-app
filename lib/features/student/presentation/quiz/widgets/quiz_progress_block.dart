import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:elara/shared/widgets/segmented_progress_bar.dart';
import 'package:flutter/material.dart';

class QuizProgressBlock extends StatelessWidget {
  const QuizProgressBlock({
    super.key,
    required this.moduleLabel,
    required this.currentQuestion,
    required this.totalQuestions,
    this.progressSegmentTotal,
  });

  final String moduleLabel;
  final int currentQuestion;
  final int totalQuestions;

  final int? progressSegmentTotal;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final secondary = isDark
        ? DarkModeColors.textSecondary
        : LightModeColors.textSecondary;
    final labelTotal = totalQuestions <= 0 ? 1 : totalQuestions;
    final index = currentQuestion.clamp(1, labelTotal);

    final barTotalRaw = progressSegmentTotal ?? totalQuestions;
    final barTotal = barTotalRaw <= 0 ? 1 : barTotalRaw;
    final barIndex = currentQuestion.clamp(1, barTotal);
    final progress = barIndex / barTotal;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                moduleLabel,
                style: AppTypography.h6(
                  color: AppColors.brandPrimary500,
                ).copyWith(fontWeight: AppTypography.extraBold, height: 1.5),
              ),
            ),
            Text(
              'Question $index of $labelTotal',
              style: AppTypography.labelRegular(color: secondary),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.spacingXs),
        SegmentedProgressBar(
          progress: progress,
          trackColor: AppColors.brandPrimary100.withValues(alpha: 0.5),
        ),
      ],
    );
  }
}
