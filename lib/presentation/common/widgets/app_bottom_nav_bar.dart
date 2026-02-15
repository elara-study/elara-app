import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_radius.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:flutter/material.dart';

/// Custom bottom nav bar with elevation, rounded corners, and no filled background.
/// Selection is shown by icon change (outlined → filled).
class AppBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<AppNavBarItem> items;

  const AppBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.paddingOf(context).bottom;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final selectedColor = isDark
        ? AppColors.brandPrimary400
        : AppColors.brandPrimary500;
    final unselectedColor = isDark
        ? AppColors.neutral500
        : AppColors.neutral600;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.spacingLg,
        AppSpacing.spacingSm,
        AppSpacing.spacingLg,
        bottomPadding + AppSpacing.spacingLg,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: isDark
              ? DarkModeColors.surfacePrimary
              : LightModeColors.surfacePrimary,
          borderRadius: BorderRadius.circular(AppRadius.radiusXl),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withOpacity(0.15),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
            BoxShadow(
              color: AppColors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.radiusXl),
          child: Material(
            color: Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: AppSpacing.spacingSm,
                horizontal: AppSpacing.spacingMd,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(items.length, (i) {
                  final item = items[i];
                  final isSelected = currentIndex == i;
                  return Expanded(
                    child: InkWell(
                      onTap: () => onTap(i),
                      borderRadius: BorderRadius.circular(AppRadius.radiusMd),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: AppSpacing.spacingMd,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              isSelected ? item.selectedIcon : item.icon,
                              size: 24,
                              color: isSelected
                                  ? selectedColor
                                  : unselectedColor,
                            ),
                            const SizedBox(height: AppSpacing.spacingXs),
                            Text(
                              item.label,
                              style: AppTypography.labelSmall(
                                color: isSelected
                                    ? selectedColor
                                    : unselectedColor,
                              ),
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
        ),
      ),
    );
  }
}

/// Item for [AppBottomNavBar].
class AppNavBarItem {
  final IconData icon;
  final IconData selectedIcon;
  final String label;

  const AppNavBarItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
  });
}
