import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_radius.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppStatTile extends StatelessWidget {
  final String icon;
  final String label;
  final String value;
  final Color backgroundColor;

  const AppStatTile({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.spacingLg.w,
        vertical: AppSpacing.spacingXl.h,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppRadius.radiusLg.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SvgPicture.asset(
                icon,
                width: AppSpacing.spacingMd.w,
                height: AppSpacing.spacingMd.h,
                colorFilter: const ColorFilter.mode(
                  AppColors.neutral50,
                  BlendMode.srcIn,
                ),
              ),
              SizedBox(width: AppSpacing.spacingXs.w),
              Expanded(
                child: Text(
                  label,
                  style: AppTypography.labelSmall(
                    color: AppColors.neutral50,
                  ).copyWith(fontWeight: AppTypography.semiBold),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
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
