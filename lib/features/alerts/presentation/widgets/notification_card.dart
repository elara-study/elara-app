import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_radius.dart';
import 'package:elara/core/theme/app_shadows.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:elara/features/alerts/domain/entities/alert_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// A single notification card matching the Figma Alerts design.
///
/// White card with rounded corners, icon circle on the left, title + date
/// on the first row, and body text below.
class NotificationCard extends StatelessWidget {
  final AlertEntity alert;

  const NotificationCard({super.key, required this.alert});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: EdgeInsets.all(AppSpacing.spacingLg.w),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(AppRadius.radiusLg.r),
        boxShadow: AppShadows.elevationLight,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44.w,
            height: 44.w,
            decoration: const BoxDecoration(
              color: AppColors.neutral100,
              shape: BoxShape.circle,
            ),
            child: Padding(
              padding: EdgeInsets.all(12.r),
              child: SvgPicture.asset(
                alert.iconAsset,
                fit: BoxFit.contain,
                colorFilter: ColorFilter.mode(
                  alert.iconColor,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),

          SizedBox(width: AppSpacing.spacingMd.w),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        alert.title,
                        style: AppTypography.labelRegular(
                          color: cs.onSurface,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(width: AppSpacing.spacingSm.w),
                    Text(
                      alert.date,
                      style: AppTypography.caption(
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppSpacing.spacing2xs.h),
                Text(
                  alert.body,
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
    );
  }
}
