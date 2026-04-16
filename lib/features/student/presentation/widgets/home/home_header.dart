import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_radius.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Home screen top bar — elara SVG wordmark + notification badge chip + points chip.
class HomeHeader extends StatelessWidget {
  final int notificationCount;
  final int points;

  const HomeHeader({
    super.key,
    required this.notificationCount,
    required this.points,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          'elara',
          style: AppTypography.h5(
            font: "Comfortaa",
            color: LightModeColors.textPrimary,
          ).copyWith(fontWeight: FontWeight.bold),
        ),

        const Spacer(),

        //   Streak / notification chip
        _HeaderChip(
          iconAsset: 'assets/icons/fire_icon.svg',
          label: '$notificationCount',
          color: AppColors.brandSecondary500,
        ),

        SizedBox(width: 8.w),

        //   Points chip
        _HeaderChip(
          iconAsset: 'assets/icons/rewards_icon.svg',
          label: '$points',
          color: AppColors.brandPrimary500,
        ),
      ],
    );
  }
}

class _HeaderChip extends StatelessWidget {
  final String iconAsset;
  final String label;
  final Color color;

  const _HeaderChip({
    required this.iconAsset,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadius.radiusFull),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            iconAsset,
            width: 10.w,
            height: 13.w,
            colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
          ),
          SizedBox(width: 4.w),
          Text(label, style: AppTypography.labelRegular(color: color)),
        ],
      ),
    );
  }
}
