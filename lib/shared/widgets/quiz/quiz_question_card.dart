import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_radius.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:elara/core/theme/app_shadows.dart';
import 'package:flutter/material.dart';

/// Question container: left accent (same pattern as [AnnouncementCard] / Elara insight), chips, prompt.
class QuizQuestionCard extends StatelessWidget {
  const QuizQuestionCard({
    super.key,
    required this.questionText,
    this.pointsLabel = '+10',
    this.hintLabel = 'HINT',
    this.onHint,
  });

  final String questionText;
  final String pointsLabel;
  final String hintLabel;
  final VoidCallback? onHint;

  static const double _accentWidth = 3;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final surface = theme.colorScheme.surface;
    final onSurface = theme.colorScheme.onSurface;
    final secondaryOrange = isDark
        ? AppColors.brandSecondary400
        : AppColors.brandSecondary500;
    final chipBg = AppColors.brandSecondary500Alpha10;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(AppRadius.radiusLg),
        border: Border(
          left: BorderSide(
            color: secondaryOrange,
            width: _accentWidth,
          ),
        ),
        boxShadow: AppShadows.elevation(theme.brightness),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.spacingLg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.spacingMd,
                    vertical: AppSpacing.spacingSm,
                  ),
                  decoration: BoxDecoration(
                    color: chipBg,
                    borderRadius: BorderRadius.circular(AppRadius.radiusFull),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.bolt_rounded,
                        size: 16,
                        color: secondaryOrange,
                      ),
                      const SizedBox(width: AppSpacing.spacingXs),
                      Text(
                        pointsLabel,
                        style: AppTypography.labelRegular(
                          color: secondaryOrange,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Material(
                  color: AppColors.brandSecondary500,
                  borderRadius: BorderRadius.circular(AppRadius.radiusFull),
                  child: InkWell(
                    onTap: onHint,
                    borderRadius: BorderRadius.circular(AppRadius.radiusFull),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.spacingSm,
                        vertical: AppSpacing.spacingXs,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            hintLabel,
                            style: AppTypography.labelMedium(
                              color: AppColors.white,
                            ).copyWith(
                              fontWeight: AppTypography.semiBold,
                              fontSize: 12,
                              height: 1.33,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.spacingXs),
                          const Icon(
                            Icons.lightbulb_outline_rounded,
                            size: 16,
                            color: AppColors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.spacingMd),
            Text(
              questionText,
              style: AppTypography.labelRegular(color: onSurface),
            ),
          ],
        ),
      ),
    );
  }
}
