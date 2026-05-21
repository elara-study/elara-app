import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_radius.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

//   AssignmentOverviewCard

/// Shared overview card used on both the student homework screen and the
/// teacher homework management screen.
class AssignmentOverviewCard extends StatelessWidget {
  final int totalXp;

  final int? completedProblems;

  final int? totalProblems;

  final double? progressPercent;

  const AssignmentOverviewCard({
    super.key,
    required this.totalXp,
    this.completedProblems,
    this.totalProblems,
    this.progressPercent,
  });

  /// Whether to render the progress section.
  bool get _showProgress =>
      completedProblems != null &&
      totalProblems != null &&
      progressPercent != null;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSpacing.spacing2xl.w),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(AppRadius.radiusXl.r),
        boxShadow: [
          BoxShadow(
            color: cs.shadow.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //   Heading
          Text(
            'Assignment Overview',
            style: AppTypography.h5(
              color: cs.onSurface,
            ).copyWith(fontWeight: AppTypography.extraBold),
          ),

          SizedBox(height: AppSpacing.spacingLg.h),

          //  XP reward row
          Row(
            children: [
              SvgPicture.asset(
                'assets/icons/electric_icon.svg',
                width: 16.w,
                height: 16.w,
                colorFilter: const ColorFilter.mode(
                  AppColors.brandPrimary500,
                  BlendMode.srcIn,
                ),
              ),
              SizedBox(width: AppSpacing.spacingXs.w),
              Text(
                'Total Score',
                style: AppTypography.labelRegular(color: cs.onSurfaceVariant),
              ),
              const Spacer(),
              Text(
                '$totalXp XP',
                style: AppTypography.labelRegular(
                  color: cs.onSurface,
                ).copyWith(fontWeight: AppTypography.semiBold),
              ),
            ],
          ),

          //  Progress section
          if (_showProgress) ...[
            SizedBox(height: AppSpacing.spacingLg.h),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Overall Progress',
                  style: AppTypography.labelRegular(color: cs.onSurface),
                ),
                Text(
                  '$completedProblems/$totalProblems problems',
                  style: AppTypography.labelSmall(
                    color: cs.onSurface,
                  ).copyWith(fontWeight: AppTypography.semiBold),
                ),
              ],
            ),

            SizedBox(height: AppSpacing.spacingXs.h),

            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.radiusFull.r),
              child: LinearProgressIndicator(
                value: progressPercent,
                minHeight: 8.h,
                backgroundColor: AppColors.brandPrimary100,
                valueColor: const AlwaysStoppedAnimation<Color>(
                  AppColors.brandPrimary700,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
