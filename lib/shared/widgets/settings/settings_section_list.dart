import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'settings_card.dart';

/// Rounded settings card with dividers between rows.
class SettingsSectionList extends StatelessWidget {
  const SettingsSectionList({
    super.key,
    required this.children,
    this.leadingPadding,
  });

  final List<Widget> children;
  final EdgeInsetsGeometry? leadingPadding;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final rows = <Widget>[];
    for (var i = 0; i < children.length; i++) {
      if (i > 0) {
        rows.add(Divider(height: 1, thickness: 1, color: cs.outlineVariant));
      }
      rows.add(children[i]);
    }
    return SettingsCard(
      padding: leadingPadding ?? EdgeInsets.zero,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: rows,
      ),
    );
  }
}

/// One navigation row: leading icon, label, trailing chevron.
class SettingsNavigationTile extends StatelessWidget {
  const SettingsNavigationTile({
    super.key,
    required this.icon,
    required this.label,
    this.onTap,
    this.labelColor,
    this.iconColor,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final Color? labelColor;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final textStyleColor = labelColor ?? cs.onSurface;
    final leadingIconColor = iconColor ?? cs.onSurface;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.spacingLg.r),
          child: Row(
            children: [
              Icon(icon, size: 20.sp, color: leadingIconColor),
              SizedBox(width: AppSpacing.spacingSm.w),
              Expanded(
                child: Text(
                  label,
                  style: AppTypography.labelMedium(
                    color: textStyleColor,
                  ).copyWith(height: 20 / 14, fontSize: 14.sp),
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                size: 20.sp,
                color: iconColor ?? cs.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Row with optional leading icon, label, and [Switch] trailing.
class SettingsToggleTile extends StatelessWidget {
  const SettingsToggleTile({
    super.key,
    this.icon,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final IconData? icon;
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: EdgeInsets.all(AppSpacing.spacingLg.r),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, size: 20.sp, color: cs.onSurface),
            SizedBox(width: AppSpacing.spacingSm.w),
          ],
          Expanded(
            child: Text(
              label,
              style: AppTypography.labelMedium(
                color: cs.onSurface,
              ).copyWith(height: 20 / 14, fontSize: 14.sp),
            ),
          ),
          Switch.adaptive(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}

/// Language / compact trailing chip row.
class SettingsDenseChipTile extends StatelessWidget {
  const SettingsDenseChipTile({
    super.key,
    required this.icon,
    required this.label,
    required this.trailingLabel,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final String trailingLabel;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.spacingLg.r),
          child: Row(
            children: [
              Icon(icon, size: 20.sp, color: cs.onSurface),
              SizedBox(width: AppSpacing.spacingSm.w),
              Expanded(
                child: Text(
                  label,
                  style: AppTypography.labelMedium(
                    color: cs.onSurface,
                  ).copyWith(height: 20 / 14, fontSize: 14.sp),
                ),
              ),
              DecoratedBox(
                decoration: BoxDecoration(
                  color: cs.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.spacingSm.w,
                    vertical: AppSpacing.spacing2xs.h,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        trailingLabel,
                        style: AppTypography.labelSmall(
                          color: cs.onSurface,
                        ).copyWith(fontSize: 10.sp, height: 14 / 10),
                      ),
                      SizedBox(width: AppSpacing.spacing2xs.w),
                      Icon(
                        Icons.keyboard_arrow_down_rounded,
                        size: 16.sp,
                        color: cs.onSurface,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
