import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_radius.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

Color _fieldFill(BuildContext context) {
  return Theme.of(context).brightness == Brightness.light
      ? LightModeColors.surfaceSecondary
      : DarkModeColors.surfaceSecondary;
}

/// Keyboard-aware dialog shell for in-app forms.
///
/// Pass any [child]: a one-field flow can use [AppFormDialogBody] +
/// [AppFormDialogTextField], or compose multi-step / multi-field UI yourself.
///
/// ```dart
/// showAppFormDialog(context, child: const MyStatefulCustomForm());
///
/// showAppFormDialog(
///   context,
///   child: AppFormDialogScrollableBody(
///     title: 'Edit profile',
///     children: [
///       TextField(...),
///       SwitchListTile(...),
///       AppFormDialogPrimaryButton(label: 'Save', onPressed: () {}),
///     ],
///   ),
/// );
/// ```
Future<T?> showAppFormDialog<T>(BuildContext context, {required Widget child}) {
  return showDialog<T>(
    context: context,
    builder: (ctx) {
      final bottom = MediaQuery.viewInsetsOf(ctx).bottom;
      final scheme = Theme.of(ctx).colorScheme;
      return AnimatedPadding(
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        padding: EdgeInsets.only(bottom: bottom),
        child: Dialog(
          backgroundColor: scheme.surface,
          surfaceTintColor: Colors.transparent,
          insetPadding: EdgeInsets.symmetric(
            horizontal: AppSpacing.spacingLg.w,
            vertical: AppSpacing.spacingLg.h,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.radiusLg.r),
          ),
          child: child,
        ),
      );
    },
  );
}

/// Padded column with an optional title row and dismiss control.
///
/// Set [title] to null for a fully custom header inside [children], or use
/// [showCloseButton] only to get a trailing X with no title.
class AppFormDialogBody extends StatelessWidget {
  const AppFormDialogBody({
    super.key,
    this.title,
    this.showCloseButton = true,
    this.onClose,
    required this.children,
  });

  final String? title;

  /// When false, no X is shown (e.g. you provide your own actions in
  /// [children]).
  final bool showCloseButton;

  final VoidCallback? onClose;

  /// Form content below the optional header (fields, switches, buttons, …).
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final close = onClose ?? () => Navigator.of(context).pop();
    return Padding(
      padding: EdgeInsets.all(AppSpacing.spacingLg.r),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _AppFormDialogHeader(
            title: title,
            showCloseButton: showCloseButton,
            onClose: close,
          ),
          ...children,
        ],
      ),
    );
  }
}

/// Same as [AppFormDialogBody] but wraps [children] in a [SingleChildScrollView]
/// for longer or keyboard-heavy forms.
class AppFormDialogScrollableBody extends StatelessWidget {
  const AppFormDialogScrollableBody({
    super.key,
    this.title,
    this.showCloseButton = true,
    this.onClose,
    required this.children,
  });

  final String? title;
  final bool showCloseButton;
  final VoidCallback? onClose;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final close = onClose ?? () => Navigator.of(context).pop();
    return Padding(
      padding: EdgeInsets.all(AppSpacing.spacingLg.r),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _AppFormDialogHeader(
              title: title,
              showCloseButton: showCloseButton,
              onClose: close,
            ),
            ...children,
          ],
        ),
      ),
    );
  }
}

class _AppFormDialogHeader extends StatelessWidget {
  const _AppFormDialogHeader({
    required this.title,
    required this.showCloseButton,
    required this.onClose,
  });

  final String? title;
  final bool showCloseButton;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;
    if (title == null && !showCloseButton) {
      return const SizedBox.shrink();
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (title != null)
              Expanded(
                child: Text(title!, style: AppTypography.h5(color: onSurface)),
              )
            else
              const Spacer(),
            if (showCloseButton) AppFormDialogCloseButton(onPressed: onClose),
          ],
        ),
        SizedBox(height: AppSpacing.spacingLg.h),
      ],
    );
  }
}

/// Clear / dismiss control — matches Figma compact hit target.
class AppFormDialogCloseButton extends StatelessWidget {
  const AppFormDialogCloseButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;
    return IconButton(
      onPressed: onPressed,
      style: IconButton.styleFrom(
        minimumSize: Size(20.w, 20.h),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        padding: EdgeInsets.zero,
      ),
      icon: SvgPicture.asset(
        'assets/icons/clear_icon.svg',
        width: 20.w,
        height: 20.h,
        colorFilter: ColorFilter.mode(onSurface, BlendMode.srcIn),
      ),
    );
  }
}

/// Convenience filled single-line field — use custom [TextField]s when you need
/// more control (validation, obscureText, suffix icons, …).
class AppFormDialogTextField extends StatelessWidget {
  const AppFormDialogTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.textInputAction,
    this.onSubmitted,
    this.keyboardType,
    this.obscureText = false,
    this.maxLines = 1,
    this.onChanged,
  });

  final TextEditingController controller;
  final String hintText;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onSubmitted;
  final TextInputType? keyboardType;
  final bool obscureText;
  final int maxLines;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return TextField(
      controller: controller,
      cursorColor: scheme.primary,
      style: AppTypography.bodySmall(color: scheme.onSurface),
      textInputAction: textInputAction,
      keyboardType: keyboardType,
      obscureText: obscureText,
      onSubmitted: onSubmitted,
      maxLines: maxLines,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: AppTypography.bodySmall(
          color: scheme.onSurfaceVariant,
        ).copyWith(height: 18 / 12),
        filled: true,
        fillColor: _fieldFill(context),
        contentPadding: EdgeInsets.symmetric(
          horizontal: AppSpacing.spacingMd.w,
          vertical: maxLines > 1
              ? AppSpacing.spacingMd.h
              : AppSpacing.spacingSm.h,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.radiusMd.r),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.radiusMd.r),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.radiusMd.r),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

/// Full-width primary CTA — pair with other actions in [children] as needed.
class AppFormDialogPrimaryButton extends StatelessWidget {
  const AppFormDialogPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.brandPrimary500,
        foregroundColor: AppColors.white,
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.spacingSm.w,
          vertical: AppSpacing.spacingXs.h,
        ),
        minimumSize: Size(double.infinity, 40.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.radiusFull.r),
        ),
      ),
      child: Text(
        label,
        style: AppTypography.labelSmall(
          color: AppColors.white,
        ).copyWith(height: 16 / 12),
      ),
    );
  }
}
