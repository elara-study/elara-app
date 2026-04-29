import 'dart:ui';

import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_radius.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Drawer footer: primary New Chat button.
class HistoryPanelBottomBar extends StatelessWidget {
  const HistoryPanelBottomBar({super.key, required this.onNewChat});

  final VoidCallback onNewChat;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final theme = Theme.of(context);
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: cs.surface.withValues(alpha: 0.94),
            border: Border(top: BorderSide(color: cs.outlineVariant)),
          ),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: EdgeInsets.all(AppSpacing.spacingLg.w),
              child: FilledButton.icon(
                onPressed: onNewChat,
                icon: Icon(Icons.add_rounded, size: 22.sp),
                label: Text(
                  'New Chat',
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                    fontSize: 16.sp,
                    height: 24 / 16,
                    color: LightModeColors.textPrimaryInverse,
                  ),
                ),
                style: FilledButton.styleFrom(
                  backgroundColor: cs.primary,
                  foregroundColor: cs.onPrimary,
                  minimumSize: Size(double.infinity, 52.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.radiusMd.r),
                  ),
                  elevation: 2,
                  shadowColor: cs.shadow.withValues(alpha: 0.15),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
