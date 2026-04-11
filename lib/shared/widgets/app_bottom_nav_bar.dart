import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// A custom styled bottom navigation bar used across all student screens.
///
/// Uses SVG icons from [assets/icons/]. Active tab tints the icon with
/// [brandPrimary500]; inactive tabs use [neutral400].
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
    return Container(
      decoration: BoxDecoration(
        color: LightModeColors.surfacePrimary,
        boxShadow: [
          BoxShadow(
            color: AppColors.neutral900.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64.h,
          child: Row(
            children: List.generate(_tabs.length, (index) {
              final tab = _tabs[index];
              final isActive = currentIndex == index;
              final color = isActive
                  ? AppColors.brandPrimary500
                  : AppColors.neutral400;

              return Expanded(
                child: GestureDetector(
                  onTap: () => onTap(index),
                  behavior: HitTestBehavior.opaque,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    curve: Curves.easeInOut,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          tab.assetPath,
                          width: 22.w,
                          height: 22.w,
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
                ),
              );
            }),
          ),
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
