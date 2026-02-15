import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_radius.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:flutter/material.dart';

/// Gradient button - rounded, shadow, optional icon circle.
/// Pass [gradient] to choose style: AppGradients.primary, .secondary, .accent, or custom.
class AppGradientButton extends StatelessWidget {
  final String text;
  final String secondaryText;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final Color iconColor;
  final LinearGradient gradient;

  const AppGradientButton({
    super.key,
    required this.text,
    required this.secondaryText,
    this.iconColor = AppColors.white,
    this.onPressed,
    this.isLoading = false,
    this.icon,
    this.gradient = AppGradients.primary,
  });

  @override
  Widget build(BuildContext context) {
    final shadowColor = gradient.colors.isNotEmpty
        ? gradient.colors.last.withOpacity(0.3)
        : AppColors.brandPrimary500.withOpacity(0.3);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isLoading ? null : onPressed,
        borderRadius: BorderRadius.circular(AppRadius.radiusLg),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.spacing2xl,
            vertical: AppSpacing.spacingLg,
          ),
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(AppRadius.radiusFull),
            boxShadow: [
              BoxShadow(
                color: shadowColor,
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: isLoading
              ? const Center(
                  child: SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.white,
                      ),
                    ),
                  ),
                )
              : icon != null
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: iconColor,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(icon, size: 20, color: AppColors.white),
                    ),
                    const SizedBox(width: AppSpacing.spacingLg),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          text,
                          style: AppTypography.labelLarge(
                            color: AppColors.neutral50,
                          ),
                        ),
                        Text(
                          secondaryText,
                          style: AppTypography.bodySmall(
                            color: AppColors.neutral200,
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              : Text(text, style: AppTypography.button(color: AppColors.white)),
        ),
      ),
    );
  }
}

/// Primary button
class AppPrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;

  const AppPrimaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: ButtonColors.primaryDefault,
        foregroundColor: ButtonColors.primaryText,
        disabledBackgroundColor: ButtonColors.primaryDisabled,
        disabledForegroundColor: ButtonColors.primaryTextDisabled,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.spacing2xl,
          vertical: AppSpacing.spacingLg,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.radiusSm),
        ),
        elevation: 0,
      ),
      child: isLoading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  ButtonColors.primaryText,
                ),
              ),
            )
          : icon != null
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 20),
                const SizedBox(width: AppSpacing.spacingSm),
                Text(text, style: AppTypography.button()),
              ],
            )
          : Text(text, style: AppTypography.button()),
    );
  }
}

/// Secondary button
class AppSecondaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;

  const AppSecondaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: ButtonColors.secondaryDefault,
        foregroundColor: ButtonColors.secondaryText,
        disabledBackgroundColor: ButtonColors.secondaryDisabled,
        disabledForegroundColor: ButtonColors.secondaryTextDisabled,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.spacing2xl,
          vertical: AppSpacing.spacingLg,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.radiusSm),
        ),
        elevation: 0,
      ),
      child: isLoading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  ButtonColors.secondaryText,
                ),
              ),
            )
          : icon != null
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 20),
                const SizedBox(width: AppSpacing.spacingSm),
                Text(text, style: AppTypography.button()),
              ],
            )
          : Text(text, style: AppTypography.button()),
    );
  }
}

/// Ghost button
class AppGhostButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;

  const AppGhostButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: isLoading ? null : onPressed,
      style:
          TextButton.styleFrom(
            foregroundColor: ButtonColors.ghostText,
            disabledForegroundColor: ButtonColors.ghostTextDisabled,
            backgroundColor: Colors.transparent,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.spacing2xl,
              vertical: AppSpacing.spacingLg,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.radiusSm),
            ),
          ).copyWith(
            overlayColor: WidgetStateProperty.resolveWith<Color?>((states) {
              if (states.contains(WidgetState.pressed))
                return ButtonColors.ghostPressed;
              if (states.contains(WidgetState.hovered))
                return ButtonColors.ghostHover;
              return null;
            }),
          ),
      child: isLoading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  ButtonColors.ghostText,
                ),
              ),
            )
          : icon != null
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 20),
                const SizedBox(width: AppSpacing.spacingSm),
                Text(text, style: AppTypography.button()),
              ],
            )
          : Text(text, style: AppTypography.button()),
    );
  }
}

/// Outline button
class AppOutlineButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;

  const AppOutlineButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: isLoading ? null : onPressed,
      style:
          OutlinedButton.styleFrom(
            foregroundColor: ButtonColors.outlineText,
            disabledForegroundColor: ButtonColors.outlineTextDisabled,
            side: BorderSide(
              color: onPressed == null
                  ? ButtonColors.outlineBorderDisabled
                  : ButtonColors.outlineBorder,
              width: 1,
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.spacing2xl,
              vertical: AppSpacing.spacingLg,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.radiusSm),
            ),
          ).copyWith(
            overlayColor: WidgetStateProperty.resolveWith<Color?>((states) {
              if (states.contains(WidgetState.pressed))
                return ButtonColors.outlinePressed;
              if (states.contains(WidgetState.hovered))
                return ButtonColors.outlineHover;
              return null;
            }),
          ),
      child: isLoading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  ButtonColors.outlineText,
                ),
              ),
            )
          : icon != null
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 20),
                const SizedBox(width: AppSpacing.spacingSm),
                Text(text, style: AppTypography.button()),
              ],
            )
          : Text(text, style: AppTypography.button()),
    );
  }
}
