import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_radius.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:elara/features/student/domain/entities/daily_goal_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:elara/core/theme/app_spacing.dart';

class DailyGoalItem extends StatelessWidget {
  final DailyGoalEntity goal;

  final double progressPercent;

  const DailyGoalItem({
    super.key,
    required this.goal,
    this.progressPercent = 0.5,
  });

  String get _iconAsset => goal.isCompleted
      ? 'assets/icons/rewards_icon.svg' // trophy for completed
      : 'assets/icons/flag_icon.svg'; // flag for incomplete

  double get _barProgress => goal.isCompleted ? 1.0 : progressPercent;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final iconColor = goal.isCompleted
        ? AppColors.brandSecondary500
        : cs.onSurfaceVariant;
    final iconBg = goal.isCompleted
        ? AppColors.brandSecondary500.withValues(alpha: 0.20)
        : cs.surfaceContainerHighest;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          //   Icon circle
          Container(
            width: 44.w,
            height: 44.h,
            decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
            child: Center(
              child: SvgPicture.asset(
                _iconAsset,
                width: 15.w,
                height: 15.w,
                colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
              ),
            ),
          ),

          SizedBox(width: AppSpacing.spacingMd.w),

          // ── Label + progress bar ──────────────────────────────────────
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  goal.label,
                  style:
                      AppTypography.bodyMedium(
                        color: cs.onSurface,
                      ).copyWith(
                        decoration: goal.isCompleted
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                        decorationColor: cs.onSurface,
                      ),
                ),

                SizedBox(height: AppSpacing.spacingXs.h),

                ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadius.radiusFull.r),
                  child: LinearProgressIndicator(
                    value: _barProgress,
                    minHeight: AppSpacing.spacingSm.h,
                    backgroundColor: cs.surfaceContainerHighest,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      AppColors.brandPrimary700,
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(width: AppSpacing.spacingMd.w),

          //  ⚡ XP — design icon + text, no pill
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                'assets/icons/electric_icon.svg',
                width: AppSpacing.spacingLg.w,
                height: AppSpacing.spacingLg.h,
                colorFilter: const ColorFilter.mode(
                  AppColors.brandSecondary500,
                  BlendMode.srcIn,
                ),
              ),
              SizedBox(width: AppSpacing.spacingXs.w),
              Text(
                '+${goal.xpReward}',
                style: AppTypography.labelRegular(
                  color: AppColors.brandSecondary500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
