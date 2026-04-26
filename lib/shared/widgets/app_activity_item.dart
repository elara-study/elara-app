import 'package:elara/core/theme/app_radius.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// A single activity / notification row.
///
/// Shows a coloured icon circle on the left, bold [title] + [subtitle] in the
/// centre, and a greyed [timeAgo] label on the right — matching the "Recent
/// Activity" pattern in the Teacher Home and future Student Alerts screens.
class AppActivityItem extends StatelessWidget {
  /// SVG asset path for the icon (e.g. `'assets/icons/book_icon.svg'`).
  final String iconAsset;

  /// Background colour of the icon circle and the icon tint.
  final Color iconColor;

  /// Primary bold text.
  final String title;

  /// Secondary dimmed text below the title.
  final String subtitle;

  /// Relative time label shown on the trailing edge (e.g. `'2 min ago'`).
  final String timeAgo;

  const AppActivityItem({
    super.key,
    required this.iconAsset,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.timeAgo,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSpacing.spacingSm.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ── Icon circle ────────────────────────────────────────────────
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Padding(
              padding: EdgeInsets.all(AppSpacing.spacingSm.r),
              child: SvgPicture.asset(
                iconAsset,
                fit: BoxFit.contain,
                colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
              ),
            ),
          ),

          SizedBox(width: AppSpacing.spacingMd.w),

          // ── Title + subtitle ───────────────────────────────────────────
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: AppTypography.labelRegular(
                    color: cs.onSurface,
                  ).copyWith(fontWeight: AppTypography.semiBold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 2.h),
                Text(
                  subtitle,
                  style: AppTypography.bodySmall(color: cs.onSurfaceVariant),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          SizedBox(width: AppSpacing.spacingSm.w),

          // ── Time label ─────────────────────────────────────────────────
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.spacingSm.w,
              vertical: AppSpacing.spacing2xs.h,
            ),
            decoration: BoxDecoration(
              color: cs.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(AppRadius.radiusFull.r),
            ),
            child: Text(
              timeAgo,
              style: AppTypography.labelSmall(color: cs.onSurfaceVariant),
            ),
          ),
        ],
      ),
    );
  }
}
