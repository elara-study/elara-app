import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_radius.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:flutter/material.dart';

/// Single MCQ row: radio indicator + label (pill container).
class QuizMcqOptionTile extends StatelessWidget {
  const QuizMcqOptionTile({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final surface = theme.colorScheme.surface;
    final onSurface = theme.colorScheme.onSurface;
    final borderColor = selected
        ? AppColors.brandPrimary500
        : (isDark ? DarkModeColors.borderDefault : LightModeColors.borderDefault);

    return Material(
      color: surface,
      borderRadius: BorderRadius.circular(AppRadius.radiusFull),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.radiusFull),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.spacingLg),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.radiusFull),
            border: Border.all(color: borderColor, width: selected ? 2 : 1),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _RadioDot(selected: selected, isDark: isDark),
              const SizedBox(width: AppSpacing.spacingSm),
              Expanded(
                child: Text(
                  label,
                  style: AppTypography.labelRegular(color: onSurface),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RadioDot extends StatelessWidget {
  const _RadioDot({required this.selected, required this.isDark});

  final bool selected;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final ring = isDark ? DarkModeColors.borderDefault : LightModeColors.borderDefault;
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
                color: selected ? AppColors.brandPrimary500 : ring,
                width: 2,
              ),
            ),
          ),
          if (selected)
            Container(
              width: 10,
              height: 10,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.brandPrimary500,
              ),
            ),
        ],
      ),
    );
  }
}
