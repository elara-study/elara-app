import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_radius.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:flutter/material.dart';

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
            overlayColor: WidgetStateProperty.resolveWith<Color?>((
              Set<WidgetState> states,
            ) {
              if (states.contains(WidgetState.pressed)) {
                return ButtonColors.ghostPressed;
              }
              if (states.contains(WidgetState.hovered)) {
                return ButtonColors.ghostHover;
              }
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
            overlayColor: WidgetStateProperty.resolveWith<Color?>((
              Set<WidgetState> states,
            ) {
              if (states.contains(WidgetState.pressed)) {
                return ButtonColors.outlinePressed;
              }
              if (states.contains(WidgetState.hovered)) {
                return ButtonColors.outlineHover;
              }
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

/// Primary Reversed button
class AppPrimaryReversedButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;

  const AppPrimaryReversedButton({
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
        backgroundColor: ButtonColors.primaryReversedDefault,
        foregroundColor: ButtonColors.primaryReversedText,
        disabledBackgroundColor: ButtonColors.primaryReversedDisabled,
        disabledForegroundColor: ButtonColors.primaryReversedTextDisabled,
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
                  ButtonColors.primaryReversedText,
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

/// Secondary Reversed button
class AppSecondaryReversedButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;

  const AppSecondaryReversedButton({
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
        backgroundColor: ButtonColors.secondaryReversedDefault,
        foregroundColor: ButtonColors.secondaryReversedText,
        disabledBackgroundColor: ButtonColors.secondaryReversedDisabled,
        disabledForegroundColor: ButtonColors.secondaryReversedTextDisabled,
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
                  ButtonColors.secondaryReversedText,
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
