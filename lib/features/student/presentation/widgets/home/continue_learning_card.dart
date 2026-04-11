import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_radius.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:elara/features/student/domain/entities/course_progress_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Dark gradient card for the "Continue where you left off" section.
class ContinueLearningCard extends StatelessWidget {
  final CourseProgressEntity progress;
  final VoidCallback? onTap;

  const ContinueLearningCard({
    super.key,
    required this.progress,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.brandPrimary700, AppColors.brandPrimary900],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(AppRadius.radiusLg.r),
        ),
        child: Row(
          children: [
            // ── Left: text content ──────────────────────────────────────────
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Caption
                  Row(
                    children: [
                      Icon(
                        Icons.access_time_rounded,
                        size: 12.sp,
                        color: AppColors.neutral400,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        'Continue where you left off',
                        style: AppTypography.caption(
                          color: AppColors.neutral400,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 8.h),

                  // Course name
                  Text(
                    progress.courseName,
                    style: AppTypography.h5(color: AppColors.white),
                  ),

                  SizedBox(height: 2.h),

                  // Lesson label
                  Text(
                    progress.lessonLabel,
                    style: AppTypography.bodySmall(color: AppColors.neutral300),
                  ),

                  SizedBox(height: 12.h),

                  // Progress bar + percentage
                  Row(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4.r),
                          child: LinearProgressIndicator(
                            value: progress.progressPercent,
                            minHeight: 6.h,
                            backgroundColor: AppColors.white.withValues(alpha: 0.15),
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              AppColors.brandPrimary300,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Text(
                        '${(progress.progressPercent * 100).round()}%',
                        style: AppTypography.labelMedium(
                          color: AppColors.brandPrimary300,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(width: 16.w),

            // ── Right: play button ──────────────────────────────────────────
            Container(
              width: 44.w,
              height: 44.w,
              decoration: BoxDecoration(
                color: AppColors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.white.withValues(alpha: 0.25),
                    blurRadius: 12,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Icon(
                Icons.play_arrow_rounded,
                color: AppColors.brandPrimary700,
                size: 24.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
