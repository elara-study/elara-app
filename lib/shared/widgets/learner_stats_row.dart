import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/shared/widgets/stat_column_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Day Streak, Total XP, and Lessons — same tiles as student profile overview.
class LearnerStatsRow extends StatelessWidget {
  const LearnerStatsRow({
    super.key,
    required this.streakDays,
    required this.totalXpDisplay,
    required this.lessonsCount,
  });

  final int streakDays;

  /// Grouping/formatting is left to the caller (profile comma helper, intl, …).
  final String totalXpDisplay;

  final int lessonsCount;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: StatColumnCard(
            color: AppColors.brandSecondary500,
            titleColor: AppColors.brandSecondary50,
            subtitleColor: AppColors.brandSecondary100,
            value: '$streakDays',
            label: 'Day Streak',
            svgAsset: 'assets/icons/fire_icon.svg',
          ),
        ),
        SizedBox(width: AppSpacing.spacingLg.w),
        Expanded(
          child: StatColumnCard(
            color: AppColors.brandPrimary500,
            titleColor: AppColors.brandPrimary50,
            subtitleColor: AppColors.brandPrimary100,
            value: totalXpDisplay,
            label: 'Total XP',
            svgAsset: 'assets/icons/electric_icon.svg',
          ),
        ),
        SizedBox(width: AppSpacing.spacingLg.w),
        Expanded(
          child: StatColumnCard(
            color: AppColors.success500,
            titleColor: AppColors.success50,
            subtitleColor: AppColors.success100,
            value: '$lessonsCount',
            label: 'Lessons',
            svgAsset: 'assets/icons/book_icon.svg',
          ),
        ),
      ],
    );
  }
}
