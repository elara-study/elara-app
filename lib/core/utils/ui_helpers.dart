import 'package:elara/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class UiHelpers {
  /// Returns a time-appropriate greeting (e.g. Good morning, Good afternoon, Good evening).
  static String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  /// Resolves the primary gradient colour for a group based on its colour key.
  static Color getGroupPrimaryColor(String? colorKey) {
    switch (colorKey) {
      case 'orange':
        return AppColors.brandSecondary500;
      case 'green':
        return AppColors.success500;
      default:
        return AppColors.brandPrimary500;
    }
  }

  /// Resolves the secondary gradient colour for a group based on its colour key.
  static Color getGroupSecondaryColor(String? colorKey) {
    switch (colorKey) {
      case 'orange':
        return AppColors.brandSecondary400;
      case 'green':
        return AppColors.success400;
      default:
        return AppColors.brandPrimary400;
    }
  }
}
