import 'package:elara/core/enums/roadmap_module_status.dart';
import 'package:elara/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

/// Theme tokens for [RoadmapModuleStatus] in the roadmap UI (presentation only).
extension RoadmapModuleStatusUi on RoadmapModuleStatus {
  IconData get leadingIcon => switch (this) {
        RoadmapModuleStatus.completed => Icons.check_rounded,
        RoadmapModuleStatus.inProgress => Icons.play_arrow_rounded,
        RoadmapModuleStatus.locked => Icons.lock_outline_rounded,
      };

  Color get leadingIconColor => switch (this) {
        RoadmapModuleStatus.completed => AppColors.white,
        RoadmapModuleStatus.inProgress => AppColors.brandPrimary500,
        RoadmapModuleStatus.locked => AppColors.neutral300,
      };

  Color get leadingCircleFill => switch (this) {
        RoadmapModuleStatus.completed => AppColors.brandPrimary500,
        RoadmapModuleStatus.inProgress => AppColors.brandPrimary500Alpha10,
        RoadmapModuleStatus.locked => Colors.transparent,
      };

  BoxBorder? get leadingCircleBorder => switch (this) {
        RoadmapModuleStatus.completed => null,
        RoadmapModuleStatus.inProgress => Border.all(
            color: AppColors.brandPrimary500,
          ),
        RoadmapModuleStatus.locked => Border.all(color: AppColors.neutral300),
      };

  /// Background and foreground for the small status chip.
  ({Color background, Color foreground}) chipColors(ColorScheme scheme) {
    return switch (this) {
      RoadmapModuleStatus.completed => (
          background: AppColors.brandPrimary500Alpha20,
          foreground: AppColors.brandPrimary500,
        ),
      RoadmapModuleStatus.inProgress => (
          background: AppColors.brandPrimary500,
          foreground: AppColors.neutral50,
        ),
      RoadmapModuleStatus.locked => (
          background: scheme.surfaceContainerHighest,
          foreground: scheme.onSurfaceVariant,
        ),
    };
  }

  ({Color color, double width}) moduleCardBorder(ColorScheme scheme) {
    if (isInProgress) {
      return (color: AppColors.brandPrimary500, width: 1.0);
    }
    if (isLocked) {
      return (color: scheme.outlineVariant, width: 1.0);
    }
    return (color: Colors.transparent, width: 0.0);
  }

  Color moduleCardSurface(ColorScheme scheme) =>
      isLocked ? scheme.surfaceContainerHighest : scheme.surface;

  bool get moduleCardShowsShadow => !isLocked;

  Color moduleLabelColor(ColorScheme scheme) =>
      isLocked ? scheme.onSurfaceVariant : AppColors.brandPrimary500;

  Color moduleTitleColor(ColorScheme scheme) =>
      isLocked ? scheme.onSurfaceVariant : scheme.onSurface;
}
