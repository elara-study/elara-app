import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_gradients.dart';
import 'package:elara/core/theme/app_radius.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:elara/features/parent/domain/home/entities/parent_child_progress_entity.dart';
import 'package:elara/shared/widgets/learner_stats_row.dart';
import 'package:elara/shared/widgets/segmented_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

/// Detailed child card — Figma Child Card (Detailed) `1460:10218`.
class ParentChildDashboardCard extends StatelessWidget {
  const ParentChildDashboardCard({
    super.key,
    required this.child,
    this.onOpenDetail,
  });

  final ParentChildProgressEntity child;
  final VoidCallback? onOpenDetail;

  static final _xpFmt = NumberFormat.decimalPattern();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final bodyTopR = (AppRadius.radiusXl + 8).r;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.radiusLg.r),
        gradient: AppGradients.brandPrimaryHorizontal,
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.all(AppSpacing.spacingLg.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 24.r,
                  backgroundColor: AppColors.white.withValues(alpha: 0.25),
                  child: Text(
                    child.displayName.isNotEmpty
                        ? child.displayName[0].toUpperCase()
                        : '?',
                    style: AppTypography.h5(color: AppColors.white),
                  ),
                ),
                SizedBox(width: AppSpacing.spacingSm.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        child.displayName,
                        style: AppTypography.h5(color: AppColors.white),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: AppSpacing.spacingXs.h),
                      Row(
                        children: [
                          if (child.gradeLabel.isNotEmpty) ...[
                            _GradeChip(label: child.gradeLabel),
                            SizedBox(width: AppSpacing.spacingSm.w),
                            Text(
                              '•',
                              style: AppTypography.labelSmall(
                                color: AppColors.white.withValues(alpha: 0.7),
                              ),
                            ),
                            SizedBox(width: AppSpacing.spacingSm.w),
                          ],
                          Text(
                            'Level ${child.level}',
                            style: AppTypography.labelSmall(
                              color: AppColors.white.withValues(alpha: 0.85),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Material(
                  color: AppColors.white,
                  shape: const CircleBorder(),
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: onOpenDetail,
                    child: Padding(
                      padding: EdgeInsets.all(AppSpacing.spacingSm.w),
                      child: Icon(
                        Icons.chevron_right_rounded,
                        color: AppColors.brandPrimary500,
                        size: 22.sp,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: cs.surface,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(bodyTopR),
                topRight: Radius.circular(bodyTopR),
                bottomLeft: Radius.circular(AppRadius.radiusLg.r),
                bottomRight: Radius.circular(AppRadius.radiusLg.r),
              ),
            ),
            padding: EdgeInsets.fromLTRB(
              AppSpacing.spacingLg.w,
              AppSpacing.spacing2xl.h,
              AppSpacing.spacingLg.w,
              AppSpacing.spacingLg.h,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                LearnerStatsRow(
                  streakDays: child.streakDays,
                  totalXpDisplay: _xpFmt.format(child.xpPoints),
                  lessonsCount: child.currentLesson,
                ),
                if (child.subjectGroups.isNotEmpty) ...[
                  SizedBox(height: AppSpacing.spacingLg.h),
                  Text(
                    'SUBJECT GROUP PROGRESS',
                    style:
                        AppTypography.labelRegular(
                          color: cs.onSurfaceVariant,
                        ).copyWith(
                          letterSpacing: 0.5,
                          fontWeight: AppTypography.semiBold,
                        ),
                  ),
                  SizedBox(height: AppSpacing.spacingMd.h),
                  for (final g in child.subjectGroups) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            g.name,
                            style: AppTypography.bodySmall(color: cs.onSurface),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          '${g.progressPercentRounded}%',
                          style: AppTypography.bodySmall(color: cs.onSurface),
                        ),
                      ],
                    ),
                    SizedBox(height: AppSpacing.spacingXs.h),
                    SegmentedProgressBar(
                      progress: g.progress,
                      height: AppSpacing.spacingSm,
                    ),
                    SizedBox(height: AppSpacing.spacingMd.h),
                  ],
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GradeChip extends StatelessWidget {
  const _GradeChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.spacingSm.w,
        vertical: 2.h,
      ),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(AppRadius.radiusFull.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.school_outlined, size: 12.sp, color: AppColors.white),
          SizedBox(width: 4.w),
          Text(label, style: AppTypography.labelSmall(color: AppColors.white)),
        ],
      ),
    );
  }
}
