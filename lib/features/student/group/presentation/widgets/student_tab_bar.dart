import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_shadows.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:flutter/material.dart';

class StudentTabBar extends StatelessWidget {
  final List<Tab> tabs;

  const StudentTabBar({super.key, required this.tabs});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    const height = 36.0;

    return Padding(
      padding: const EdgeInsets.symmetric(
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
                color: AppColors.neutral50,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
