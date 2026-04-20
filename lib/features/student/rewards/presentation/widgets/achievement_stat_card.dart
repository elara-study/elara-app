import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_radius.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AchievementStatCard extends StatelessWidget {
  /// Primary display value, e.g. "1,250" or "7 days".
  final String value;

  /// Subtitle label below the value, e.g. "Total XP".
  final String label;

  /// Path to the SVG icon shown on the right.
  final String svgAsset;

  /// Solid background colour for this card.
  final Color cardColor;

  const AchievementStatCard({
    super.key,
    required this.value,
    required this.label,
    required this.svgAsset,
    required this.cardColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(AppRadius.radiusMd.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ── Value + label (left) ────────────────────────────────────────
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  value,
                  style: AppTypography.h5(
                    color: AppColors.white,
                  ).copyWith(fontWeight: FontWeight.w800),
                ),
                SizedBox(height: 2.h),
                Text(
                  label,
                  style: AppTypography.labelSmall(
                    color: AppColors.white.withValues(alpha: 0.85),
                  ),
                ),
              ],
            ),
          ),

          // ── Icon in frosted circle (right) ─────────────────────────────
          Container(
            width: 36.w,
            height: 36.w,
            decoration: BoxDecoration(
              color: AppColors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: SvgPicture.asset(
                svgAsset,
                width: 18.w,
                height: 18.w,
                colorFilter: const ColorFilter.mode(
                  AppColors.white,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
