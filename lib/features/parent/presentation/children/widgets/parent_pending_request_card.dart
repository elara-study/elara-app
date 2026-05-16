import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_radius.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:elara/features/parent/domain/home/entities/parent_pending_request_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Single pending link request — Figma Pending Request Card.
class ParentPendingRequestCard extends StatelessWidget {
  const ParentPendingRequestCard({
    super.key,
    required this.request,
    this.onDecline,
    this.onAccept,
  });

  final ParentPendingRequestEntity request;
  final VoidCallback? onDecline;
  final VoidCallback? onAccept;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(AppRadius.radiusLg.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.spacingLg.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 18.r,
                  backgroundColor: cs.primaryContainer,
                  child: Text(
                    request.displayName.isNotEmpty
                        ? request.displayName[0].toUpperCase()
                        : '?',
                    style: AppTypography.labelRegular(
                      color: cs.onPrimaryContainer,
                    ).copyWith(fontWeight: AppTypography.bold),
                  ),
                ),
                SizedBox(width: AppSpacing.spacingSm.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        request.displayName,
                        style: AppTypography.labelRegular(
                          color: cs.onSurface,
                        ).copyWith(fontWeight: AppTypography.semiBold),
                      ),
                      SizedBox(height: AppSpacing.spacingXs.h),
                      Text(
                        '${request.gradeLabel} • ${request.requestedTimeLabel}',
                        style: AppTypography.bodySmall(
                          color: cs.onSurfaceVariant,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSpacing.spacingLg.h),
            Row(
              children: [
                Expanded(child: _DeclineRequestButton(onPressed: onDecline)),
                SizedBox(width: AppSpacing.spacingMd.w),
                Expanded(child: _AcceptRequestButton(onPressed: onAccept)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DeclineRequestButton extends StatelessWidget {
  const _DeclineRequestButton({required this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return SizedBox(
      height: 48.h,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.brandPrimary500,
          backgroundColor: cs.surface,
          side: const BorderSide(color: AppColors.brandPrimary500, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.radiusFull.r),
          ),
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.spacingSm.w),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.close_rounded, size: 20.sp),
            SizedBox(width: AppSpacing.spacing2xs.w),
            Text(
              'Decline',
              style: AppTypography.labelLarge(
                color: AppColors.brandPrimary500,
              ).copyWith(fontWeight: FontWeight.w600, fontSize: 14.sp),
            ),
          ],
        ),
      ),
    );
  }
}

class _AcceptRequestButton extends StatelessWidget {
  const _AcceptRequestButton({required this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48.h,
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.brandPrimary500,
          foregroundColor: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.radiusFull.r),
          ),
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.spacingSm.w),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_rounded, size: 20.sp),
            SizedBox(width: AppSpacing.spacing2xs.w),
            Text(
              'Accept',
              style: AppTypography.labelLarge(
                color: AppColors.white,
              ).copyWith(fontWeight: FontWeight.w600, fontSize: 14.sp),
            ),
          ],
        ),
      ),
    );
  }
}
