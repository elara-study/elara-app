import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_shadows.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:flutter/material.dart';

/// Pill-style segmented [TabBar] for use under [DefaultTabController] or with
/// an explicit [TabController].
class PillTabBar extends StatelessWidget {
  const PillTabBar({
    super.key,
    required this.tabs,
    this.controller,
    this.onTap,
    this.padding,
  });

  final List<Tab> tabs;
  final TabController? controller;
  final ValueChanged<int>? onTap;

  /// When null, uses horizontal [AppSpacing.spacingLg] and vertical
  /// [AppSpacing.spacingSm] (student group). Use tighter vertical-only padding
  /// when the parent already applies horizontal insets (e.g. rewards scroll).
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    const height = 36.0;

    return Padding(
      padding:
          padding ??
          const EdgeInsets.symmetric(
            horizontal: AppSpacing.spacingLg,
            vertical: AppSpacing.spacingSm,
          ),
      child: SizedBox(
        height: height,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: cs.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Padding(
            padding: const EdgeInsets.all(3),
            child: TabBar(
              controller: controller,
              onTap: onTap,
              tabs: tabs,
              dividerColor: Colors.transparent,
              splashFactory: NoSplash.splashFactory,
              overlayColor: const WidgetStatePropertyAll(Colors.transparent),
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorPadding: EdgeInsets.zero,
              labelPadding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.spacingMd,
              ),
              indicator: BoxDecoration(
                color: AppColors.brandPrimary500,
                borderRadius: BorderRadius.circular(999),
                boxShadow: AppShadows.brandPrimaryPillGlow(),
              ),
              labelColor: AppColors.white,
              unselectedLabelColor: cs.onSurfaceVariant,
              labelStyle: AppTypography.labelMedium(),
              unselectedLabelStyle: AppTypography.labelMedium(
                color: cs.onSurfaceVariant,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
