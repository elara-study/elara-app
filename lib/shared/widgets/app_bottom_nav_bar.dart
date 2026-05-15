import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_shadows.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:elara/core/theme/app_spacing.dart';

/// Configuration for a single tab in [AppBottomNavBar].
class AppNavTab {
  final String label;

  /// SVG path used when the tab is inactive.
  final String assetPath;

  /// SVG path used when the tab is active.
  /// Defaults to [assetPath] with `'.svg'` replaced by `'_filled.svg'`.
  final String? activeAssetPath;

  const AppNavTab({
    required this.label,
    required this.assetPath,
    this.activeAssetPath,
  });

  String get resolvedActiveAsset =>
      activeAssetPath ?? assetPath.replaceAll('.svg', '_filled.svg');
}

/// Floating pill-shaped bottom navigation bar.
///
/// Frosted glass: [AppShadows.backgroundBlur] (sigma 24) with a tinted
/// [ColorScheme.surface]. Shadow: [AppShadows.dropShadow] (0, 4, blur 20,
/// black 15%).
///
/// Accepts a list of [AppNavTab] configs, making it reusable for both the
/// Student shell and the Teacher shell without duplicating nav logic.
class AppBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  /// The tabs to render. Order matches the [IndexedStack] page order.
  final List<AppNavTab> tabs;

  /// Default student tabs — kept as a convenience constant so existing
  /// [StudentShell] code needs no change.
  static const List<AppNavTab> studentTabs = [
    AppNavTab(label: 'Home', assetPath: 'assets/icons/home_icon.svg'),
    AppNavTab(label: 'Learn', assetPath: 'assets/icons/learn_icon.svg'),
    AppNavTab(label: 'Rewards', assetPath: 'assets/icons/rewards_icon.svg'),
    AppNavTab(label: 'Alerts', assetPath: 'assets/icons/alerts_icon.svg'),
    AppNavTab(label: 'Profile', assetPath: 'assets/icons/profile_icon.svg'),
  ];

  /// Default teacher tabs.
  static const List<AppNavTab> teacherTabs = [
    AppNavTab(label: 'Home', assetPath: 'assets/icons/home_icon.svg'),
    AppNavTab(label: 'Groups', assetPath: 'assets/icons/people_outline.svg'),
    AppNavTab(label: 'Roadmaps', assetPath: 'assets/icons/roadmap_icon.svg'),
    AppNavTab(label: 'Alerts', assetPath: 'assets/icons/alerts_icon.svg'),
    AppNavTab(label: 'Profile', assetPath: 'assets/icons/profile_icon.svg'),
  ];

  /// Parent app
  static const List<AppNavTab> parentTabs = [
    AppNavTab(label: 'Home', assetPath: 'assets/icons/home_icon.svg'),
    AppNavTab(label: 'Children', assetPath: 'assets/icons/people_outline.svg'),
    AppNavTab(label: 'Reports', assetPath: 'assets/icons/report_icon.svg'),
    AppNavTab(label: 'Alerts', assetPath: 'assets/icons/alerts_icon.svg'),
    AppNavTab(label: 'Profile', assetPath: 'assets/icons/profile_icon.svg'),
  ];

  const AppBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.tabs = studentTabs,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final inactiveColor = cs.onSurfaceVariant;
    final radius = BorderRadius.circular(28.r);
    return SafeArea(
      top: false,
      child: Container(
        margin: EdgeInsets.only(
          left: AppSpacing.spacingLg.w,
          right: AppSpacing.spacingLg.w,
          bottom: AppSpacing.spacing2xl.h,
        ),
        decoration: BoxDecoration(
          borderRadius: radius,
          boxShadow: AppShadows.dropShadow,
        ),
        child: ClipRRect(
          borderRadius: radius,
          child: BackdropFilter(
            filter: AppShadows.backgroundBlur,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.spacingLg.w,
                vertical: AppSpacing.spacingMd.h,
              ),
              decoration: BoxDecoration(
                color: cs.surface.withValues(alpha: 0.78),
                borderRadius: radius,
                border: Border.all(
                  color: cs.outlineVariant.withValues(alpha: 0.55),
                ),
              ),
              child: Row(
                children: List.generate(tabs.length, (index) {
                  final tab = tabs[index];
                  final isActive = currentIndex == index;
                  final color = isActive
                      ? AppColors.brandPrimary700
                      : inactiveColor;

                  return Expanded(
                    child: GestureDetector(
                      onTap: () => onTap(index),
                      behavior: HitTestBehavior.opaque,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            isActive ? tab.resolvedActiveAsset : tab.assetPath,
                            fit: BoxFit.contain,
                            alignment: Alignment.center,
                            colorFilter: ColorFilter.mode(
                              color,
                              BlendMode.srcIn,
                            ),
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
          ),
        ),
      ),
    );
  }
}
