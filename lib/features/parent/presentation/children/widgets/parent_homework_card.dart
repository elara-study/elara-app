import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_shadows.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:elara/features/parent/domain/children/entities/parent_homework_card_entity.dart';
import 'package:elara/features/parent/domain/children/entities/parent_homework_status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// A premium, beautiful card representing homework progress for parents,
/// featuring the stacked rounded-corner design from the roadmap class cards.
class ParentHomeworkCard extends StatelessWidget {
  const ParentHomeworkCard({super.key, required this.entity});

  final ParentHomeworkCardEntity entity;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.brandPrimary400, AppColors.brandPrimary500],
          begin: Alignment.bottomLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(32.r),
        boxShadow: AppShadows.elevation(theme.brightness),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── White Top Card (Sits on top of the colored base) ───────────────
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: cs.surface,
              borderRadius: BorderRadius.circular(32.r),
              boxShadow: AppShadows.elevation(theme.brightness),
            ),
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        entity.moduleNumber.toUpperCase(),
                        style:
                            AppTypography.labelSmall(
                              color: cs.onSurfaceVariant,
                            ).copyWith(
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                              fontSize: 12.sp,
                            ),
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        entity.title,
                        style: AppTypography.h4(color: cs.onSurface).copyWith(
                          fontWeight: FontWeight.w800,
                          fontSize: 22.sp,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        entity.description,
                        style: AppTypography.bodyMedium(
                          color: cs.onSurfaceVariant,
                        ).copyWith(fontSize: 14.sp),
                      ),
                    ],
                  ),
                ),
                if (entity.score != null && entity.score!.isNotEmpty) ...[
                  SizedBox(width: AppSpacing.spacingMd.w),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 14.w,
                      vertical: 8.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.brandPrimary500Alpha20,
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: entity.score!.split('/').first.trim(),
                            style: AppTypography.labelSmall(color: cs.onSurface)
                                .copyWith(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 13.sp,
                                ),
                          ),
                          TextSpan(
                            text: ' / ${entity.score!.split('/').last.trim()}',
                            style:
                                AppTypography.labelSmall(
                                  color: cs.onSurfaceVariant,
                                ).copyWith(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 11.sp,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ] else if (entity.status == ParentHomeworkStatus.submitted) ...[
                  SizedBox(width: AppSpacing.spacingMd.w),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.brandPrimary500Alpha20,
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Text(
                      'SUBMITTED',
                      style:
                          AppTypography.labelSmall(
                            color: AppColors.brandPrimary500,
                          ).copyWith(
                            fontWeight: FontWeight.w700,
                            fontSize: 10.sp,
                            letterSpacing: 0.5,
                          ),
                    ),
                  ),
                ],
              ],
            ),
          ),

          // ── Colored Bottom Strip (The base container peeks out) ────────────
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  entity.subject.toUpperCase(),
                  style: AppTypography.labelLarge(color: AppColors.neutral50)
                      .copyWith(
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.2,
                        fontSize: 16.sp,
                      ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 14.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.brandPrimary400,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    entity.className,
                    style: AppTypography.labelSmall(
                      color: AppColors.neutral50,
                    ).copyWith(fontWeight: FontWeight.w700, fontSize: 12.sp),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
