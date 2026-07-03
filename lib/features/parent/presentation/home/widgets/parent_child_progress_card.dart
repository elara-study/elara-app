import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_radius.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:elara/features/parent/domain/home/entities/parent_child_progress_entity.dart';
import 'package:elara/shared/widgets/progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Child progress card — Figma "Child Card".
class ParentChildProgressCard extends StatelessWidget {
  const ParentChildProgressCard({
    super.key,
    required this.child,
    this.onOpenDetail,
  });

  final ParentChildProgressEntity child;
  final VoidCallback? onOpenDetail;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final onSurface = cs.onSurface;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: cs.surface,
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
        padding: EdgeInsets.all(AppSpacing.spacingLg.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Avatar(name: child.displayName),
                SizedBox(width: AppSpacing.spacingSm.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        child.displayName,
                        style: AppTypography.labelRegular(
                          color: onSurface,
                        ).copyWith(fontWeight: AppTypography.semiBold),
                      ),
                      SizedBox(height: AppSpacing.spacingXs.h),
                      Wrap(
                        spacing: AppSpacing.spacingXs.w,
                        runSpacing: AppSpacing.spacing2xs.h,
                        children: [
                          _StatCapsule(
                            background: AppColors.brandPrimary500Alpha10,
                            foreground: AppColors.brandPrimary500,
                            icon: Icons.emoji_events_outlined,
                            label: '${child.xpPoints}',
                          ),
                          _StatCapsule(
                            background: AppColors.brandSecondary500Alpha10,
                            foreground: AppColors.brandSecondary500,
                            icon: Icons.local_fire_department_rounded,
                            label: '${child.streakDays}',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.all(AppSpacing.spacingSm.w),
                  onPressed: onOpenDetail,
                  icon: Icon(
                    Icons.chevron_right_rounded,
                    color: onSurface,
                    size: 22.sp,
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSpacing.spacingLg.h),
            ProgressBar(
              completedLabel:
                  'Lesson ${child.currentLesson} of ${child.totalLessons}',
              percentLabel: '${child.progressPercentRounded}%',
              progress: child.progress,
              metaLabelColor: onSurface,
              trackColor: AppColors.brandPrimary100.withValues(alpha: 0.5),
            ),
          ],
        ),
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    final initial = name.isNotEmpty ? name[0].toUpperCase() : '?';
    return CircleAvatar(
      radius: 18.r,
      backgroundColor: AppColors.brandPrimary100,
      child: Text(
        initial,
        style: AppTypography.labelRegular(
          color: AppColors.brandPrimary700,
        ).copyWith(fontWeight: AppTypography.bold),
      ),
    );
  }
}

class _StatCapsule extends StatelessWidget {
  const _StatCapsule({
    required this.background,
    required this.foreground,
    required this.icon,
    required this.label,
  });

  final Color background;
  final Color foreground;
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(AppRadius.radiusFull.r),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.spacingXs.w,
          vertical: 2.h,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 12.sp, color: foreground),
            SizedBox(width: 2.w),
            Text(
              label,
              style: AppTypography.labelSmall(color: foreground).copyWith(
                fontSize: 8.sp,
                height: 1.25,
                fontWeight: AppTypography.semiBold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
