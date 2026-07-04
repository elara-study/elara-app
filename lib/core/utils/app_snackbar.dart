import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_radius.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';

enum SnackBarType { error, success, info, warning }

class AppSnackBar {
  AppSnackBar._();

  static Color _backgroundColor(SnackBarType type) {
    switch (type) {
      case SnackBarType.error:
        return AppColors.error500;
      case SnackBarType.success:
        return AppColors.success500;
      case SnackBarType.info:
        return AppColors.brandPrimary600;
      case SnackBarType.warning:
        return AppColors.warning500;
    }
  }

  static Color _accentColor(SnackBarType type) {
    switch (type) {
      case SnackBarType.error:
        return AppColors.error700;
      case SnackBarType.success:
        return AppColors.success700;
      case SnackBarType.info:
        return AppColors.brandPrimary700;
      case SnackBarType.warning:
        return AppColors.warning700;
    }
  }

  static IconData _icon(SnackBarType type) {
    switch (type) {
      case SnackBarType.error:
        return Icons.error_outline_rounded;
      case SnackBarType.success:
        return Icons.check_circle_outline_rounded;
      case SnackBarType.info:
        return Icons.info_outline_rounded;
      case SnackBarType.warning:
        return Icons.warning_amber_rounded;
    }
  }

  static void show(
    BuildContext context,
    String message, {
    SnackBarType type = SnackBarType.info,
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
  }) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.clearSnackBars();

    final bgColor = _backgroundColor(type);
    final accentColor = _accentColor(type);

    scaffold.showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        duration: duration,
        backgroundColor: Colors.transparent,
        elevation: 0,
        margin: const EdgeInsets.symmetric(
          horizontal: AppSpacing.spacingLg,
          vertical: AppSpacing.spacingSm,
        ),
        content: _ModernSnackBarContent(
          message: message,
          type: type,
          bgColor: bgColor,
          accentColor: accentColor,
          action: action,
        ),
        action: action,
      ),
    );
  }

  static void error(BuildContext context, String message, {SnackBarAction? action, Duration? duration}) {
    show(context, message, type: SnackBarType.error, action: action, duration: duration ?? const Duration(seconds: 3));
  }

  static void success(BuildContext context, String message, {SnackBarAction? action, Duration? duration}) {
    show(context, message, type: SnackBarType.success, action: action, duration: duration ?? const Duration(seconds: 3));
  }

  static void info(BuildContext context, String message, {SnackBarAction? action, Duration? duration}) {
    show(context, message, type: SnackBarType.info, action: action, duration: duration ?? const Duration(seconds: 3));
  }

  static void warning(BuildContext context, String message, {SnackBarAction? action, Duration? duration}) {
    show(context, message, type: SnackBarType.warning, action: action, duration: duration ?? const Duration(seconds: 3));
  }
}

class _ModernSnackBarContent extends StatelessWidget {
  final String message;
  final SnackBarType type;
  final Color bgColor;
  final Color accentColor;
  final SnackBarAction? action;

  const _ModernSnackBarContent({
    required this.message,
    required this.type,
    required this.bgColor,
    required this.accentColor,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.spacingMd,
        vertical: AppSpacing.spacingSm + 2,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppRadius.radiusMd),
        border: Border(
          left: BorderSide(color: accentColor, width: 4),
        ),
        boxShadow: [
          BoxShadow(
            color: bgColor.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            AppSnackBar._icon(type),
            color: AppColors.white,
            size: 22,
          ),
          const SizedBox(width: AppSpacing.spacingSm),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: AppColors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
