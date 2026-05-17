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

  /// When null, only vertical [AppSpacing.spacingSm] is applied — set
  /// horizontal insets here (e.g. [AppSpacing.spacingLg]) at the call site.
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    const height = AppSpacing.spacing4xl;

    return Padding(
      padding:
          padding ?? const EdgeInsets.symmetric(vertical: AppSpacing.spacingSm),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SizedBox(
            width: constraints.maxWidth,
            height: height,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: cs.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: TabBar(
                  controller: controller,
                  onTap: onTap,
                  tabs: tabs,
                  isScrollable: false,
                  tabAlignment: TabAlignment.fill,
                  dividerColor: Colors.transparent,
                  splashFactory: NoSplash.splashFactory,
                  overlayColor: const WidgetStatePropertyAll(
                    Colors.transparent,
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicatorPadding: EdgeInsets.zero,
                  labelPadding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.spacingSm,
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
          );
        },
      ),
    );
  }
}
