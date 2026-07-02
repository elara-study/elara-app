import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_radius.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:elara/shared/widgets/app_dialog.dart';
import 'package:flutter/material.dart';

void showQuizLeaveDialog(BuildContext context, {required String quizTitle}) {
  AppDialog.show(
    context: context,
    builder: (ctx) {
      final cs = Theme.of(context).colorScheme;
      return AppDialog(
        // We leave title null to hide the default header with the close icon.
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon Container
            Center(
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.brandSecondary500.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.logout_rounded,
                  color: AppColors.brandSecondary500,
                  size: 24,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.spacingLg),

            // Title
            Text(
              'Leave Quiz?',
              textAlign: TextAlign.center,
              style: AppTypography.h5(
                color: cs.onSurface,
              ).copyWith(fontWeight: AppTypography.extraBold),
            ),
            const SizedBox(height: AppSpacing.spacingSm),

            // Subtitle
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: AppTypography.bodyMedium(color: cs.onSurfaceVariant),
                children: [
                  const TextSpan(text: 'Are you sure you want to leave '),
                  TextSpan(
                    text: quizTitle,
                    style: AppTypography.bodyMedium(
                      color: cs.onSurface,
                    ).copyWith(fontWeight: AppTypography.bold),
                  ),
                  const TextSpan(text: ' quiz?'),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.spacing2xl),

            // Buttons
            ElevatedButton(
              onPressed: () {
                Navigator.of(ctx).pop(); // close dialog
                Navigator.of(context).maybePop(); // leave quiz
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error500,
                foregroundColor: AppColors.white,
                padding: const EdgeInsets.symmetric(
                  vertical: AppSpacing.spacingMd,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.radiusFull),
                ),
                elevation: 0,
              ),
              child: Text(
                'Leave Quiz',
                style: AppTypography.h5(color: AppColors.white),
              ),
            ),
            const SizedBox(height: AppSpacing.spacingMd),
            OutlinedButton(
              onPressed: () => Navigator.of(ctx).pop(),
              style: OutlinedButton.styleFrom(
                foregroundColor: ButtonColors.outlineText,
                side: const BorderSide(color: ButtonColors.outlineBorder),
                padding: const EdgeInsets.symmetric(
                  vertical: AppSpacing.spacingMd,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.radiusFull),
                ),
              ),
              child: Text(
                'Cancel',
                style: AppTypography.labelLarge(
                  color: ButtonColors.outlineText,
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}
