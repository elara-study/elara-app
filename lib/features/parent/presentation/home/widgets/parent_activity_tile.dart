import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_radius.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:elara/features/parent/domain/home/entities/parent_activity_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Recent activity row — Figma "Notification Card".
class ParentActivityTile extends StatelessWidget {
  const ParentActivityTile({super.key, required this.activity});

  final ParentActivityEntity activity;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final onSurface = cs.onSurface;
    final secondary = cs.onSurfaceVariant;
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
        child: Row(
          children: [
            DecoratedBox(
              decoration: const BoxDecoration(
                color: AppColors.neutral100,
                shape: BoxShape.circle,
              ),
              child: Padding(
                padding: EdgeInsets.all(AppSpacing.spacingMd.w),
                child: Icon(
                  Icons.notifications_outlined,
                  size: 20.sp,
                  color: AppColors.brandPrimary500,
                ),
              ),
            ),
            SizedBox(width: AppSpacing.spacingMd.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          activity.title,
                          style: AppTypography.labelRegular(
                            color: onSurface,
                          ).copyWith(fontWeight: AppTypography.semiBold),
                        ),
                      ),
                      Text(
                        activity.timeLabel,
                        style: AppTypography.caption(color: secondary),
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    activity.subtitle,
                    style: AppTypography.bodySmall(color: secondary),
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
