import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:elara/core/theme/app_shadows.dart';
import 'package:flutter/material.dart';

/// Frosted header with optional back control, title, and subtitle (matches Figma Quiz app bar).
class QuizFrostedAppBar extends StatelessWidget {
  const QuizFrostedAppBar({
    super.key,
    required this.title,
    required this.subtitle,
    this.onBack,
    this.showBackButton = true,
  });

  final String title;
  final String subtitle;
  final VoidCallback? onBack;

  /// Results screen in Figma hides the back icon (title + meta only).
  final bool showBackButton;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final surface = isDark
        ? DarkModeColors.surfaceApp.withValues(alpha: 0.7)
        : LightModeColors.surfaceApp.withValues(alpha: 0.7);
    final borderColor = isDark
        ? DarkModeColors.borderDefault
        : LightModeColors.borderDefault;
    final titleColor = theme.colorScheme.onSurface;
    final subtitleColor = isDark
        ? DarkModeColors.textSecondary
        : LightModeColors.textSecondary;

    return ClipRect(
      child: BackdropFilter(
        filter: AppShadows.backgroundBlur,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: surface,
            border: Border(bottom: BorderSide(color: borderColor)),
          ),
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.spacingXs,
                AppSpacing.spacingLg,
                AppSpacing.spacingLg,
                AppSpacing.spacingLg,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (showBackButton)
                    IconButton(
                      padding: const EdgeInsets.all(AppSpacing.spacingMd),
                      onPressed:
                          onBack ?? () => Navigator.of(context).maybePop(),
                      icon: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: titleColor,
                        size: 22,
                      ),
                    )
                  else
                    const SizedBox(width: AppSpacing.spacingLg),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          title,
                          style: AppTypography.h4(
                            color: titleColor,
                            font: AppTypography.comfortaa,
                          ).copyWith(fontWeight: AppTypography.bold, height: 1.4),
                        ),
                        const SizedBox(height: AppSpacing.spacing2xs),
                        Text(
                          subtitle,
                          style: AppTypography.bodyMedium(color: subtitleColor),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
