import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:elara/features/student/domain/entities/daily_goal_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// A single daily goal row — icon + label + XP reward chip.
/// Completed goals show a green checkmark and muted text.
class DailyGoalItem extends StatelessWidget {
  final DailyGoalEntity goal;

  const DailyGoalItem({super.key, required this.goal});

  IconData get _icon {
    switch (goal.iconKey) {
      case 'book':
        return Icons.flag_outlined;
      case 'quiz':
        return Icons.track_changes_outlined;
      case 'timer':
        return Icons.timer_outlined;
      default:
        return Icons.task_alt_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final textColor = goal.isCompleted
        ? LightModeColors.textSecondary
        : LightModeColors.textPrimary;
    final iconColor = goal.isCompleted
        ? AppColors.success500
        : AppColors.brandPrimary500;
    final iconBg = goal.isCompleted
        ? AppColors.success500.withValues(alpha: 0.1)
        : AppColors.brandPrimary500.withValues(alpha: 0.1);

    return Row(
      children: [
        // Icon circle
        Container(
          width: 36.w,
          height: 36.w,
          decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
          child: Icon(
            goal.isCompleted ? Icons.check_rounded : _icon,
            size: 18.sp,
            color: iconColor,
          ),
        ),

        SizedBox(width: 12.w),

        // Label
        Expanded(
          child: Text(
            goal.label,
            style: AppTypography.bodyMedium(color: textColor).copyWith(
              decoration: goal.isCompleted
                  ? TextDecoration.lineThrough
                  : TextDecoration.none,
            ),
          ),
        ),

        // XP chip
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
          decoration: BoxDecoration(
            color: AppColors.brandAccent500.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Text(
            '+${goal.xpReward}',
            style: AppTypography.labelSmall(color: AppColors.brandAccent600),
          ),
        ),
      ],
    );
  }
}
