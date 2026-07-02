import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_radius.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:flutter/material.dart';

/// Shows the hint for the current question in a styled bottom sheet.
/// Matches the module_sheet.dart presentation pattern.
void showHintSheet(BuildContext context, String hint) {
  final theme = Theme.of(context);
  showModalBottomSheet<void>(
    context: context,
    useRootNavigator: true,
    useSafeArea: true,
    showDragHandle: true,
    backgroundColor: theme.colorScheme.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(AppRadius.radiusLg),
      ),
    ),
    builder: (_) => _HintSheet(hint: hint),
  );
}

class _HintSheet extends StatelessWidget {
  const _HintSheet({required this.hint});
  final String hint;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final secondaryOrange = Theme.of(context).brightness == Brightness.dark
        ? AppColors.brandSecondary400
        : AppColors.brandSecondary500;

    final titleStyle =
        Theme.of(context).textTheme.headlineMedium?.copyWith(
      fontWeight: FontWeight.w800,
    );

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.spacingLg,
        AppSpacing.spacingSm,
        AppSpacing.spacingLg,
        AppSpacing.spacingXl,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.lightbulb_outline_rounded,
                color: secondaryOrange,
                size: 22,
              ),
              const SizedBox(width: AppSpacing.spacingSm),
              Expanded(child: Text('Hint', style: titleStyle)),
              IconButton(
                icon: const Icon(Icons.close_rounded),
                tooltip: MaterialLocalizations.of(context).closeButtonLabel,
                onPressed: () => Navigator.of(context).pop(),
                style: IconButton.styleFrom(foregroundColor: cs.onSurface),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.spacingMd),

          // Hint body
          Container(
            padding: const EdgeInsets.all(AppSpacing.spacingLg),
            decoration: BoxDecoration(
              color: AppColors.brandSecondary500Alpha10,
              borderRadius: BorderRadius.circular(AppRadius.radiusMd),
              border: Border.all(
                color: secondaryOrange.withValues(alpha: 0.3),
              ),
            ),
            child: Text(
              hint,
              style: AppTypography.bodyMedium(color: cs.onSurface),
            ),
          ),
        ],
      ),
    );
  }
}
