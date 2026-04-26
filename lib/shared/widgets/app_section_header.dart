import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:elara/core/theme/app_spacing.dart';

/// A reusable "Title + See All ›" section header row.
///
/// Used wherever a content section has a labelled header and an optional
/// "See All" action — e.g. My Groups, My Roadmaps, Recent Activity.
///
/// When [onSeeAll] is `null` the button is hidden entirely (e.g. Recent
/// Activity where there is no detail page yet).
class AppSectionHeader extends StatelessWidget {
  final String title;

  /// Callback for the "See All" button. Pass `null` to hide it.
  final VoidCallback? onSeeAll;

  /// Button label — defaults to 'See All'.
  final String seeAllLabel;

  const AppSectionHeader({
    super.key,
    required this.title,
    this.onSeeAll,
    this.seeAllLabel = 'See All',
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: AppTypography.h4(
            color: cs.onSurface,
          ).copyWith(fontWeight: FontWeight.w900),
        ),
        if (onSeeAll != null)
          GestureDetector(
            onTap: onSeeAll,
            behavior: HitTestBehavior.opaque,
            child: Padding(
              // Extra tap area without extra visual space
              padding: EdgeInsets.symmetric(vertical: 4.h),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    seeAllLabel,
                    style: AppTypography.labelSmall(
                      color: ButtonColors.ghostText,
                    ),
                  ),
                  SizedBox(width: 2.w),
                  SvgPicture.asset(
                    'assets/icons/right_arrow_ios.svg',
                    width: AppSpacing.spacingLg.w,
                    height: AppSpacing.spacingLg.w,
                    colorFilter: const ColorFilter.mode(
                      ButtonColors.ghostText,
                      BlendMode.srcIn,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
