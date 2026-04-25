import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_radius.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AchievementStatCard extends StatelessWidget {
  final String value;
  final String label;
  final String svgAsset;
  final Color cardColor;
  final Color iconBgColor;
  final Color textColor;

  const AchievementStatCard({
    super.key,
    required this.value,
    required this.label,
    required this.svgAsset,
    required this.cardColor,
    required this.iconBgColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minHeight: 76.h),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(AppRadius.radiusLg.r),
      ),
      child: Stack(
        clipBehavior: Clip.antiAlias,
        children: [
          Positioned(
            right: -14.w,
            top: -20.w,
            width: 104.w,
            height: 104.w,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: AppColors.brandPrimary50.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
            ),
          ),

          // ── Foreground content ──────────────────────────────────────────
          Padding(
            padding: EdgeInsets.all(AppSpacing.spacingLg.r),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Value + label (left)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        value,
                        style: AppTypography.h5(
                          color: AppColors.brandPrimary50,
                        ).copyWith(fontWeight: AppTypography.extraBold),
                      ),
                      Text(
                        label,
                        style: AppTypography.bodySmall(color: textColor),
                      ),
                    ],
                  ),
                ),

                // Icon circle
                Container(
                  width: 44.w,
                  height: 44.w,
                  decoration: BoxDecoration(
                    color: iconBgColor,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(AppSpacing.spacingMd.r),
                      child: SvgPicture.asset(
                        svgAsset,
                        width: 20.w,
                        height: 20.w,
                        colorFilter: ColorFilter.mode(
                          cardColor,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
