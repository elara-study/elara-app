import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_radius.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTabBar extends StatelessWidget {
  final List<String> tabs;
  final int activeTab;
  final ValueChanged<int> onTabChanged;

  const AppTabBar({
    super.key,
    required this.tabs,
    required this.activeTab,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppSpacing.spacing4xl.h,
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.spacingXs.w,
        vertical: AppSpacing.spacing2xs.h,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.radiusFull.r),
      ),
      child: Row(
        children: List.generate(tabs.length, (index) {
          return _TabItem(
            label: tabs[index],
            index: index,
            activeTab: activeTab,
            onTap: () => onTabChanged(index),
          );
        }),
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  final String label;
  final int index;
  final int activeTab;
  final VoidCallback onTap;

  const _TabItem({
    required this.label,
    required this.index,
    required this.activeTab,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = activeTab == index;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          padding: EdgeInsets.symmetric(
            vertical: AppSpacing.spacingXs.h,
            horizontal: AppSpacing.spacing2xs.w,
          ),
          decoration: BoxDecoration(
            color: isActive ? AppColors.brandPrimary500 : Colors.transparent,
            borderRadius: BorderRadius.circular(AppRadius.radiusFull.r),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: AppTypography.button(
              color: isActive
                  ? AppColors.neutral50
                  : Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ),
    );
  }
}
