import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_radius.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:elara/features/student/rewards/domain/entities/leaderboard_entry_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LeaderboardEntryTile extends StatelessWidget {
  final LeaderboardEntryEntity entry;

  const LeaderboardEntryTile({super.key, required this.entry});

  /// Formats [xp] with a thousands comma: 3240 → "3,240".
  static String _formatXp(int xp) {
    final str = xp.toString();
    if (str.length <= 3) return str;
    final front = str.substring(0, str.length - 3);
    final tail = str.substring(str.length - 3);
    return '$front,$tail';
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: entry.isCurrentUser
            ? AppColors.brandPrimary500Alpha10
            : Colors.transparent,
        borderRadius: entry.isCurrentUser
            ? BorderRadius.circular(AppRadius.radiusMd.r)
            : null,
        border: entry.isCurrentUser
            ? Border.all(
                color: AppColors.brandPrimary500.withValues(alpha: 0.25),
                width: 1,
              )
            : null,
      ),
      child: Row(
        children: [
          //   Rank number
          SizedBox(
            width: 22.w,
            child: Text(
              '${entry.rank}',
              style: AppTypography.bodyMedium(
                color: LightModeColors.textSecondary,
              ),
            ),
          ),

          SizedBox(width: 10.w),

          //   Avatar circle
          CircleAvatar(
            radius: 18.r,
            backgroundColor: AppColors.neutral200,
            child: Icon(
              Icons.person_rounded,
              size: 18.sp,
              color: AppColors.neutral400,
            ),
          ),

          SizedBox(width: 10.w),

          //   Name
          Expanded(
            child: Text(
              entry.name,
              style:
                  AppTypography.bodyMedium(
                    color: entry.isCurrentUser
                        ? AppColors.brandPrimary700
                        : LightModeColors.textPrimary,
                  ).copyWith(
                    fontWeight: entry.isCurrentUser
                        ? FontWeight.w700
                        : FontWeight.w500,
                  ),
            ),
          ),

          SizedBox(width: 8.w),

          //   XP with lightning bolt
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                'assets/icons/electric_icon.svg',
                width: 13.w,
                height: 13.w,
                colorFilter: const ColorFilter.mode(
                  AppColors.brandSecondary500,
                  BlendMode.srcIn,
                ),
              ),
              SizedBox(width: 3.w),
              Text(
                _formatXp(entry.xp),
                style: AppTypography.labelMedium(
                  color: LightModeColors.textPrimary,
                ).copyWith(fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
