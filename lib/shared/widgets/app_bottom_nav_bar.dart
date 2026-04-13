import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Floating pill-shaped bottom navigation bar.
///
/// Renders as a white rounded card floating above the screen background,
/// with horizontal margins and a soft shadow — matching the design.
class AppBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  static const _tabs = [
    _NavTab(label: 'Home', assetPath: 'assets/icons/home_icon.svg'),
    _NavTab(label: 'Learn', assetPath: 'assets/icons/learn_icon.svg'),
    _NavTab(label: 'Rewards', assetPath: 'assets/icons/rewards_icon.svg'),
    _NavTab(label: 'Alerts', assetPath: 'assets/icons/alerts_icon.svg'),
    _NavTab(label: 'Profile', assetPath: 'assets/icons/profile_icon.svg'),
  ];

  const AppBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        // Floating white pill card
        margin: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 24.h),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: LightModeColors.surfacePrimaryAlpha80,
          borderRadius: BorderRadius.circular(28.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.neutral900.withValues(alpha: 0.08),
              blurRadius: 20,
              spreadRadius: 0,
              offset: const Offset(0, 4),
            ),
            BoxShadow(
              color: AppColors.neutral900.withValues(alpha: 0.04),
              blurRadius: 6,
              spreadRadius: 0,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          children: List.generate(_tabs.length, (index) {
            final tab = _tabs[index];
            final isActive = currentIndex == index;
            final color = isActive
                ? AppColors.brandPrimary700
                : AppColors.neutral400;

            return Expanded(
              child: GestureDetector(
                onTap: () => onTap(index),
                behavior: HitTestBehavior.opaque,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      tab.assetPath,
                      width: 22.r,
                      height: 22.r,
                      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
                    ),
                    SizedBox(height: 3.h),
                    Text(
                      tab.label,
                      style: AppTypography.labelMedium(color: color),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class _NavTab {
  final String label;
  final String assetPath;

  const _NavTab({required this.label, required this.assetPath});
}
