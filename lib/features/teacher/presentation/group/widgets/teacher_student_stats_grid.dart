import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/features/student/presentation/rewards/widgets/achievement_stat_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 2×2 stat cards on the group student profile (Figma Stats Container).
class TeacherStudentStatsGrid extends StatelessWidget {
  const TeacherStudentStatsGrid({
    super.key,
    required this.totalXpDisplay,
    required this.lessonsLabel,
    required this.streakLabel,
    required this.attendanceLabel,
  });

  final String totalXpDisplay;
  final String lessonsLabel;
  final String streakLabel;
  final String attendanceLabel;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: AchievementStatCard(
                value: totalXpDisplay,
                label: 'Total XP',
                svgAsset: 'assets/icons/electric_icon.svg',
                cardColor: AppColors.brandPrimary500,
                iconBgColor: AppColors.brandPrimary200,
                textColor: AppColors.brandPrimary100,
              ),
            ),
            SizedBox(width: AppSpacing.spacingLg.w),
            Expanded(
              child: AchievementStatCard(
                value: lessonsLabel,
                label: 'Lessons',
                svgAsset: 'assets/icons/book_icon.svg',
                cardColor: AppColors.success500,
                iconBgColor: AppColors.success200,
                textColor: AppColors.success100,
              ),
            ),
          ],
        ),
        SizedBox(height: AppSpacing.spacingLg.h),
        Row(
          children: [
            Expanded(
              child: AchievementStatCard(
                value: streakLabel,
                label: 'Streak',
                svgAsset: 'assets/icons/fire_icon.svg',
                cardColor: AppColors.brandSecondary500,
                iconBgColor: AppColors.brandSecondary200,
                textColor: AppColors.brandSecondary100,
              ),
            ),
            SizedBox(width: AppSpacing.spacingLg.w),
            Expanded(
              child: AchievementStatCard(
                value: attendanceLabel,
                label: 'Attendance',
                svgAsset: 'assets/icons/rewards_icon.svg',
                cardColor: AppColors.brandAccent500,
                iconBgColor: AppColors.brandAccent200,
                textColor: AppColors.brandAccent100,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
