import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_radius.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:elara/features/student/domain/entities/student_group_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Subject group card — matching the design with SVG icons.
class SubjectGroupCard extends StatelessWidget {
  final StudentGroupEntity group;
  final VoidCallback? onTap;

  const SubjectGroupCard({super.key, required this.group, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: LightModeColors.surfacePrimary,
          borderRadius: BorderRadius.circular(AppRadius.radiusLg.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.neutral900.withValues(alpha: 0.06),
              blurRadius: 12,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Subject header band ──────────────────────────────────────
            Container(
              width: double.infinity,
              color: AppColors.brandPrimary600,
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
              child: Row(
                children: [
                  Text(
                    group.subject,
                    style: AppTypography.overline(color: AppColors.white)
                        .copyWith(
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                    ),
                  ),

                  const Spacer(),

                  // Grade chip with graduation cap SVG
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 3.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.white.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.asset(
                          'assets/icons/graduation_cap_icon.svg',
                          width: 11.w,
                          height: 11.w,
                          colorFilter: const ColorFilter.mode(
                            AppColors.white,
                            BlendMode.srcIn,
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          group.grade,
                          style: AppTypography.labelSmall(
                            color: AppColors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ── White card body ──────────────────────────────────────────
            Padding(
              padding: EdgeInsets.all(14.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    group.teacherName,
                    style: AppTypography.bodySmall(
                      color: LightModeColors.textSecondary,
                    ),
                  ),

                  SizedBox(height: 2.h),

                  // Course name + right arrow SVG
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          group.name,
                          style: AppTypography.h6(
                            color: LightModeColors.textPrimary,
                          ),
                        ),
                      ),
                      SvgPicture.asset(
                        'assets/icons/right_arrow_ios.svg',
                        width: 18.w,
                        height: 18.w,
                        colorFilter: const ColorFilter.mode(
                          LightModeColors.textSecondary,
                          BlendMode.srcIn,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 8.h),

                  // Stats row — people_outline + book SVGs, both orange
                  Row(
                    children: [
                      SvgPicture.asset(
                        'assets/icons/people_outline.svg',
                        width: 13.w,
                        height: 13.w,
                        colorFilter: const ColorFilter.mode(
                          AppColors.brandSecondary500,
                          BlendMode.srcIn,
                        ),
                      ),
                      SizedBox(width: 3.w),
                      Text(
                        '${group.studentCount} students',
                        style: AppTypography.bodySmall(
                          color: AppColors.brandSecondary500,
                        ).copyWith(fontWeight: FontWeight.w600),
                      ),
                      SizedBox(width: 14.w),
                      SvgPicture.asset(
                        'assets/icons/book_icon.svg',
                        width: 13.w,
                        height: 13.w,
                        colorFilter: const ColorFilter.mode(
                          AppColors.brandSecondary500,
                          BlendMode.srcIn,
                        ),
                      ),
                      SizedBox(width: 3.w),
                      Text(
                        group.lessonProgressLabel,
                        style: AppTypography.bodySmall(
                          color: AppColors.brandSecondary500,
                        ).copyWith(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),

                  SizedBox(height: 10.h),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Your progress',
                        style: AppTypography.bodySmall(
                          color: LightModeColors.textSecondary,
                        ),
                      ),
                      Text(
                        '${(group.progressPercent * 100).round()}%',
                        style: AppTypography.labelRegular(
                          color: AppColors.brandPrimary700,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 5.h),

                  ClipRRect(
                    borderRadius: BorderRadius.circular(4.r),
                    child: LinearProgressIndicator(
                      value: group.progressPercent,
                      minHeight: 6.h,
                      backgroundColor: AppColors.neutral200,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        AppColors.brandPrimary800,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
