import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_radius.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:flutter/material.dart';

/// Leave (outline) + primary action with trailing icon (Figma quiz footer).
class QuizFooterActions extends StatelessWidget {
  const QuizFooterActions({
    super.key,
    required this.onLeave,
    required this.primaryLabel,
    required this.onPrimary,
    this.primaryEnabled = true,
  });

  final VoidCallback onLeave;
  final String primaryLabel;
  final VoidCallback onPrimary;
  final bool primaryEnabled;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OutlinedButton(
          onPressed: onLeave,
          style: OutlinedButton.styleFrom(
            foregroundColor: ButtonColors.outlineText,
            side: const BorderSide(color: ButtonColors.outlineBorder),
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.spacingLg,
              vertical: AppSpacing.spacingSm,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.radiusFull),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.arrow_back_rounded, size: 20),
              const SizedBox(width: AppSpacing.spacingSm),
              Text(
                'Leave',
                style: AppTypography.labelLarge(color: ButtonColors.outlineText),
              ),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.spacingLg),
        Expanded(
          child: ElevatedButton(
            onPressed: primaryEnabled ? onPrimary : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: ButtonColors.primaryDefault,
              foregroundColor: ButtonColors.primaryText,
              disabledBackgroundColor: ButtonColors.primaryDisabled,
              disabledForegroundColor: ButtonColors.primaryTextDisabled,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.spacingLg,
                vertical: AppSpacing.spacingSm,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.radiusFull),
              ),
              elevation: 0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  primaryLabel,
                  style: AppTypography.labelLarge(color: ButtonColors.primaryText),
                ),
                const SizedBox(width: AppSpacing.spacingSm),
                const Icon(Icons.arrow_forward_rounded, size: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
