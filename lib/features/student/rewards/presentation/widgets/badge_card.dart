import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_radius.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:elara/features/student/rewards/domain/entities/badge_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BadgeCard extends StatelessWidget {
  final BadgeEntity badge;

  const BadgeCard({super.key, required this.badge});

  @override
  Widget build(BuildContext context) {
    return badge.isUnlocked ? _UnlockedCard(badge) : _LockedCard(badge);
  }
}

//   Unlocked (golden)

class _UnlockedCard extends StatelessWidget {
  final BadgeEntity badge;
  const _UnlockedCard(this.badge);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: AppColors.brandAccent500,
        borderRadius: BorderRadius.circular(AppRadius.radiusMd.r),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Trophy icon
          SvgPicture.asset(
            'assets/icons/rewards_icon.svg',
            width: 36.w,
            height: 36.w,
            colorFilter: const ColorFilter.mode(
              AppColors.white,
              BlendMode.srcIn,
            ),
          ),

          SizedBox(height: 10.h),

          // Badge name
          Text(
            badge.name,
            textAlign: TextAlign.center,
            style: AppTypography.labelMedium(
              color: AppColors.white,
            ).copyWith(fontWeight: FontWeight.w700),
          ),

          SizedBox(height: 4.h),

          // Short description
          Text(
            badge.description,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.labelSmall(
              color: AppColors.white.withValues(alpha: 0.85),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Locked (gray + progress)

class _LockedCard extends StatelessWidget {
  final BadgeEntity badge;
  const _LockedCard(this.badge);

  @override
  Widget build(BuildContext context) {
    final hasProgress = badge.progressTotal > 0;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: AppColors.neutral100,
        borderRadius: BorderRadius.circular(AppRadius.radiusMd.r),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Lock icon
          Icon(
            Icons.lock_outline_rounded,
            size: 30.sp,
            color: AppColors.neutral400,
          ),

          SizedBox(height: 10.h),

          // Badge name
          Text(
            badge.name,
            textAlign: TextAlign.center,
            style: AppTypography.labelMedium(
              color: LightModeColors.textPrimary,
            ).copyWith(fontWeight: FontWeight.w700),
          ),

          SizedBox(height: 4.h),

          // Short description
          Text(
            badge.description,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.labelSmall(
              color: LightModeColors.textSecondary,
            ),
          ),

          if (hasProgress) ...[
            SizedBox(height: 10.h),

            // Thin progress bar
            ClipRRect(
              borderRadius: BorderRadius.circular(4.r),
              child: LinearProgressIndicator(
                value: badge.progressPercent,
                minHeight: 4.h,
                backgroundColor: AppColors.neutral200,
                valueColor: const AlwaysStoppedAnimation<Color>(
                  AppColors.brandPrimary700,
                ),
              ),
            ),

            SizedBox(height: 4.h),

            // Progress fraction
            Text(
              '${badge.progressCurrent}/${badge.progressTotal}',
              style: AppTypography.labelSmall(
                color: LightModeColors.textSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
