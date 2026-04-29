import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TodayChip extends StatelessWidget {
  const TodayChip({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppSpacing.spacingMd.h),
      child: Center(
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.brandSecondary500Alpha20,
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.spacingMd.w,
              vertical: AppSpacing.spacingXs.h,
            ),
            child: Text(
              'TODAY',
              style: AppTypography.labelSmall(
                color: AppColors.brandSecondary500,
              ).copyWith(fontWeight: FontWeight.w700, letterSpacing: 0.8),
            ),
          ),
        ),
      ),
    );
  }
}
