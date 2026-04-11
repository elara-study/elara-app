import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Home screen top bar — elara wordmark + notification badge + points chip.
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
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // elara text wordmark
        SvgPicture.asset(
          'assets/images/elara.svg',
          height: 26.h,
          fit: BoxFit.contain,
        ),

        const Spacer(),

        // Notification badge chip
        _HeaderChip(
          icon: Icons.notifications_none_rounded,
          label: '$notificationCount',
          color: AppColors.brandSecondary500,
        ),

        SizedBox(width: 8.w),

        // Points chip
        _HeaderChip(
          icon: Icons.bolt_rounded,
          label: '$points',
          color: AppColors.brandAccent500,
        ),
      ],
    );
  }
}

class _HeaderChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _HeaderChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14.sp, color: color),
          SizedBox(width: 4.w),
          Text(
            label,
            style: AppTypography.labelMedium(color: color),
          ),
        ],
      ),
    );
  }
}
