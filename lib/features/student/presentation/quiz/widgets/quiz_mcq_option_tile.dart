import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_radius.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:flutter/material.dart';

/// Visual feedback state for a single option after an answer is submitted.
enum McqOptionFeedback {
  /// No answer submitted yet — normal selection style.
  none,

  /// This option was selected and is the correct answer.
  correct,

  /// This option was selected and is wrong.
  wrong,

  /// This is the correct answer but was NOT selected (shown after a wrong pick).
  correctUnselected,
}

/// Single MCQ row: radio indicator + label (pill container).
class QuizMcqOptionTile extends StatelessWidget {
  const QuizMcqOptionTile({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    this.feedback = McqOptionFeedback.none,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  /// Feedback coloring applied after submission.
  final McqOptionFeedback feedback;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final surface = theme.colorScheme.surface;
    final onSurface = theme.colorScheme.onSurface;

    // Determine border colour based on feedback first, then selection.
    final Color borderColor;
    final Color radioDotColor;
    switch (feedback) {
      case McqOptionFeedback.correct:
        borderColor = AppColors.success200;
        radioDotColor = AppColors.success200;
      case McqOptionFeedback.wrong:
        borderColor = AppColors.error300;
        radioDotColor = AppColors.error300;
      case McqOptionFeedback.correctUnselected:
        borderColor = AppColors.success200;
        radioDotColor = AppColors.success200;
      case McqOptionFeedback.none:
        borderColor = selected
            ? AppColors.brandPrimary500
            : (isDark
                  ? DarkModeColors.borderDefault
                  : LightModeColors.borderDefault);
        radioDotColor = AppColors.brandPrimary500;
    }

    final borderWidth = (selected || feedback != McqOptionFeedback.none)
        ? 2.0
        : 1.0;

    // Tapping is disabled once feedback is showing.
    final isInteractive = feedback == McqOptionFeedback.none;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: switch (feedback) {
          McqOptionFeedback.correct => AppColors.success200.withValues(
            alpha: 0.08,
          ),
          McqOptionFeedback.wrong => AppColors.error300.withValues(alpha: 0.08),
          McqOptionFeedback.correctUnselected =>
            AppColors.success200.withValues(alpha: 0.08),
          McqOptionFeedback.none => surface,
        },
        borderRadius: BorderRadius.circular(AppRadius.radiusFull),
        border: Border.all(color: borderColor, width: borderWidth),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(AppRadius.radiusFull),
        child: InkWell(
          onTap: isInteractive ? onTap : null,
          borderRadius: BorderRadius.circular(AppRadius.radiusFull),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.spacingLg),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _FeedbackDot(
                  selected:
                      selected ||
                      feedback == McqOptionFeedback.correctUnselected,
                  feedback: feedback,
                  radioDotColor: radioDotColor,
                  isDark: isDark,
                ),
                const SizedBox(width: AppSpacing.spacingSm),
                Expanded(
                  child: Text(
                    label,
                    style: AppTypography.labelRegular(color: onSurface),
                  ),
                ),
                if (feedback == McqOptionFeedback.correct || feedback == McqOptionFeedback.correctUnselected)
                  const Icon(Icons.check_circle_rounded, color: AppColors.success500, size: 20)
                else if (feedback == McqOptionFeedback.wrong)
                  const Icon(Icons.cancel_rounded, color: AppColors.error500, size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FeedbackDot extends StatelessWidget {
  const _FeedbackDot({
    required this.selected,
    required this.feedback,
    required this.radioDotColor,
    required this.isDark,
  });

  final bool selected;
  final McqOptionFeedback feedback;
  final Color radioDotColor;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final ring = isDark
        ? DarkModeColors.borderDefault
        : LightModeColors.borderDefault;
    final showFill =
        selected || feedback == McqOptionFeedback.correctUnselected;
    return SizedBox(
      width: 20,
      height: 20,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: feedback != McqOptionFeedback.none
                    ? radioDotColor
                    : (selected ? AppColors.brandPrimary500 : ring),
                width: 2,
              ),
            ),
          ),
          if (showFill)
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: radioDotColor,
              ),
            ),
        ],
      ),
    );
  }
}
