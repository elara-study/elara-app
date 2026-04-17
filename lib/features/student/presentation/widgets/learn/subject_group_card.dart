import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_radius.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:elara/features/student/domain/entities/student_group_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:elara/core/theme/app_spacing.dart';

/// Subject group card
class SubjectGroupCard extends StatelessWidget {
  final StudentGroupEntity group;
  final VoidCallback? onTap;

  const SubjectGroupCard({super.key, required this.group, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          //   The Blue Header Background
          Container(
            height: 86.w,
            width: double.infinity,
            padding: EdgeInsets.all(AppSpacing.spacingLg.w),
            decoration: BoxDecoration(
              // color: AppColors.brandPrimary400,
              gradient: const LinearGradient(
                colors: [AppColors.brandPrimary400, AppColors.brandPrimary500],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),

              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(AppRadius.radiusLg.r),
                topRight: Radius.circular(AppRadius.radiusLg.r),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  group.subject.toUpperCase(),
                  style: AppTypography.labelLarge(color: AppColors.neutral50)
                      .copyWith(
                        fontWeight: AppTypography.semiBold,
                        fontSize: 16.sp,
                      ),
                ),
                const Spacer(),
                // Grade Chip
                Container(
                  padding: EdgeInsets.symmetric(horizontal: AppSpacing.spacingSm.w, vertical: AppSpacing.spacingXs.w),
                  decoration: BoxDecoration(
                    color: AppColors.neutral50.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(AppRadius.radiusFull.r),
                  ),
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        'assets/icons/graduation_cap_icon.svg',
                        width: 14.w,
                        height: AppSpacing.spacingMd.w,
                        colorFilter: const ColorFilter.mode(
                          AppColors.neutral50,
                          BlendMode.srcIn,
                        ),
                      ),
                      SizedBox(width: AppSpacing.spacing2xs.w),
                      Text(
                        group.grade,
                        style:
                            AppTypography.labelSmall(
                              color: AppColors.neutral50,
                            ).copyWith(
                              fontWeight: AppTypography.semiBold,
                              fontSize: 12.sp,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Container(
            margin: EdgeInsets.only(top: AppSpacing.spacing7xl.w),
            decoration: BoxDecoration(
              color: LightModeColors.surfacePrimary,
              borderRadius: BorderRadius.all(
                Radius.circular(AppRadius.radiusLg.r),
              ),
            ),
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.spacingLg.w, vertical: AppSpacing.spacing2xl.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  group.teacherName,
                  style:
                      AppTypography.bodySmall(
                        color: LightModeColors.textSecondary,
                      ).copyWith(
                        fontWeight: AppTypography.regular,
                        fontSize: 12.sp,
                      ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        group.name,
                        style:
                            AppTypography.labelLarge(
                              color: LightModeColors.textPrimary,
                            ).copyWith(
                              fontWeight: AppTypography.semiBold,
                              fontSize: 20.sp,
                            ),
                      ),
                    ),
                    GestureDetector(
                      onTap: onTap,
                      child: SvgPicture.asset(
                        'assets/icons/right_arrow_ios.svg',
                        width: AppSpacing.spacing2xl.w,
                        height: AppSpacing.spacing2xl.w,
                        colorFilter: const ColorFilter.mode(
                          ButtonColors.ghostText,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppSpacing.spacingMd.h),
                // Stats Row
                Row(
                  children: [
                    SvgPicture.asset(
                      'assets/icons/people_outline.svg',
                      width: AppSpacing.spacingLg.w,
                      height: AppSpacing.spacingLg.w,
                      colorFilter: const ColorFilter.mode(
                        AppColors.brandSecondary500,
                        BlendMode.srcIn,
                      ),
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      '${group.studentCount} students',
                      style: AppTypography.bodySmall(
                        color: AppColors.brandSecondary500,
                      ).copyWith(fontWeight: AppTypography.regular),
                    ),
                    SizedBox(width: 14.w),
                    SvgPicture.asset(
                      'assets/icons/book_icon.svg',
                      width: AppSpacing.spacingLg.w,
                      height: AppSpacing.spacingLg.w,
                      colorFilter: const ColorFilter.mode(
                        AppColors.brandSecondary500,
                        BlendMode.srcIn,
                      ),
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      group.lessonProgressLabel,
                      style: AppTypography.bodySmall(
                        color: AppColors.brandSecondary500,
                      ).copyWith(fontWeight: AppTypography.regular),
                    ),
                  ],
                ),
                SizedBox(height: AppSpacing.spacingMd.h),
                // Progress Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Your progress",
                      style: AppTypography.bodyMedium(
                        color: LightModeColors.textSecondary,
                      ).copyWith(fontWeight: AppTypography.regular),
                    ),
                    Text(
                      "${(group.progressPercent * 100).round()}%",
                      style: AppTypography.bodyMedium(
                        color: LightModeColors.textPrimary,
                      ).copyWith(fontWeight: AppTypography.regular),
                    ),
                  ],
                ),
                SizedBox(height: AppSpacing.spacingXs.h),
                LinearProgressIndicator(
                  value: group.progressPercent,
                  minHeight: AppSpacing.spacingSm.h,
                  backgroundColor: AppColors.brandPrimary100,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    AppColors.brandPrimary700,
                  ), // Dark Navy
                  borderRadius: BorderRadius.circular(AppRadius.radiusFull.r),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
