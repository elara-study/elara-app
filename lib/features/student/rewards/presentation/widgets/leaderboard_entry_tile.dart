import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_radius.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:elara/features/student/rewards/domain/entities/leaderboard_entry_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LeaderboardEntryTile extends StatelessWidget {
  final LeaderboardEntryEntity entry;

  const LeaderboardEntryTile({super.key, required this.entry});

  static String _formatXp(int xp) {
    final str = xp.toString();
    if (str.length <= 3) return str;
    return '${str.substring(0, str.length - 3)},${str.substring(str.length - 3)}';
  }

  @override
  Widget build(BuildContext context) {
    final isYou = entry.isCurrentUser;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.spacingLg.w,
        vertical: 14.h,
      ),
      decoration: BoxDecoration(
        color: isYou
            ? AppColors.brandPrimary500.withValues(alpha: 0.15)
            : LightModeColors.surfacePrimary,
        borderRadius: BorderRadius.circular(AppRadius.radiusXl.r),
        border: isYou
            ? Border.all(color: AppColors.brandPrimary500, width: 1.5)
            : null,
        boxShadow: isYou
            ? null
            : [
                BoxShadow(
                  color: AppColors.neutral900.withValues(alpha: 0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Row(
        children: [
          // Rank number
          Text(
            '${entry.rank}',
            style: AppTypography.labelRegular(
              color: LightModeColors.textSecondary,
            ),
          ),

          SizedBox(width: AppSpacing.spacingSm.w),

          // Avatar circle
          CircleAvatar(
            radius: 20.r,
            backgroundColor: AppColors.neutral200,
            child: Icon(
              Icons.person_rounded,
              size: 20.sp,
              color: AppColors.neutral500,
            ),
          ),

          SizedBox(width: AppSpacing.spacingSm.w),

          // Name
          Expanded(
            child: Text(
              entry.name,
              style: AppTypography.bodyMedium(
                color: LightModeColors.textPrimary,
              ).copyWith(fontWeight: AppTypography.regular),
            ),
          ),

          // Lightning bolt + XP (dark, matching Figma)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                'assets/icons/electric_icon.svg',
                width: 14.w,
                height: 14.w,
                colorFilter: isYou
                    ? const ColorFilter.mode(
                        AppColors.brandPrimary500,
                        BlendMode.srcIn,
                      )
                    : const ColorFilter.mode(
                        LightModeColors.textPrimary,
                        BlendMode.srcIn,
                      ),
              ),
              SizedBox(width: 4.w),
              Text(
                _formatXp(entry.xp),
                style: AppTypography.labelSmall(
                  color: isYou
                      ? AppColors.brandPrimary500
                      : LightModeColors.textPrimary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
