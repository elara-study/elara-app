import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_radius.dart';
import 'package:elara/core/theme/app_shadows.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// A horizontal row of three colored stat tiles (Total, Submitted, Graded)
/// used at the top of the parent child homework screen.
class ParentHomeworkStatRow extends StatelessWidget {
  const ParentHomeworkStatRow({
    super.key,
    required this.total,
    required this.submitted,
    required this.graded,
  });

  final int total;
  final int submitted;
  final int graded;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatTile(
            label: 'Total',
            value: '$total',
            color: AppColors.brandPrimary500,
          ),
        ),
        SizedBox(width: AppSpacing.spacingSm.w),
        Expanded(
          child: _StatTile(
            label: 'Submitted',
            value: '$submitted',
            color: AppColors.brandSecondary500,
          ),
        ),
        SizedBox(width: AppSpacing.spacingSm.w),
        Expanded(
          child: _StatTile(
            label: 'Graded',
            value: '$graded',
            color: AppColors.success500,
          ),
        ),
      ],
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.spacingLg.w,
        vertical: AppSpacing.spacingLg.h,
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(AppRadius.radiusLg.r),
        boxShadow: AppShadows.elevation(Theme.of(context).brightness),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTypography.labelSmall(
              color: AppColors.neutral50,
            ).copyWith(fontWeight: AppTypography.semiBold),
          ),
          SizedBox(height: AppSpacing.spacingXs.h),
          Text(
            value,
            style: AppTypography.h3(
              color: AppColors.neutral50,
            ).copyWith(fontWeight: AppTypography.black),
          ),
        ],
      ),
    );
  }
}
