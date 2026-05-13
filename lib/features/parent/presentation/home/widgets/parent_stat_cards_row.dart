import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_radius.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:elara/features/parent/domain/home/entities/parent_aggregate_stats_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Pair of summary stat cards — Figma "Stat Card II".
class ParentStatCardsRow extends StatelessWidget {
  const ParentStatCardsRow({super.key, required this.stats});

  final ParentAggregateStatsEntity stats;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            background: AppColors.brandPrimary500,
            icon: Icons.check,
            label: 'Avg. Completion',
            value: '${stats.avgCompletionPercent}%',
          ),
        ),
        SizedBox(width: AppSpacing.spacingLg.w),
        Expanded(
          child: _StatCard(
            background: AppColors.brandSecondary500,
            icon: Icons.login,
            label: 'Avg. Attendance',
            value: '${stats.avgAttendancePercent}%',
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.background,
    required this.icon,
    required this.label,
    required this.value,
  });

  final Color background;
  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final fg = AppColors.neutral50;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(AppRadius.radiusLg.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.08),
            offset: Offset(0, 4.h),
            blurRadius: 10,
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.spacingLg.w,
          AppSpacing.spacingXl.h,
          AppSpacing.spacingLg.w,
          AppSpacing.spacingLg.h,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 24.sp, color: fg),
                SizedBox(width: AppSpacing.spacingXs.w),
                Expanded(
                  child: Text(
                    label,
                    style: AppTypography.labelMedium(color: fg),
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSpacing.spacingSm.h),
            Text(
              value,
              style: AppTypography.h3(
                color: fg,
              ).copyWith(fontWeight: AppTypography.black),
            ),
          ],
        ),
      ),
    );
  }
}
