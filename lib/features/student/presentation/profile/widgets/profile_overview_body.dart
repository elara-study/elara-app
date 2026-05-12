import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_radius.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:elara/features/auth/domain/entities/user_entity.dart';
import 'package:elara/features/student/domain/profile/entities/student_profile_overview_entity.dart';
import 'package:elara/features/student/presentation/profile/widgets/profile_level_progress_card.dart';
import 'package:elara/features/student/presentation/profile/widgets/profile_parents_section.dart';
import 'package:elara/features/student/presentation/profile/widgets/profile_recent_achievements_section.dart';
import 'package:elara/features/student/presentation/profile/widgets/profile_stat_column_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileOverviewBody extends StatelessWidget {
  const ProfileOverviewBody({
    super.key,
    required this.user,
    required this.overview,
    required this.formatThousands,
  });

  final UserEntity user;
  final StudentProfileOverviewEntity overview;
  final String Function(int) formatThousands;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        left: AppSpacing.spacingLg.w,
        right: AppSpacing.spacingLg.w,
        top: kToolbarHeight + 70.h,
        bottom: 120.w,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            children: [
              CircleAvatar(
                radius: 39.r,
                backgroundColor: cs.surfaceContainerHighest,
                child: Icon(
                  Icons.person_rounded,
                  size: 44.sp,
                  color: cs.onSurfaceVariant,
                ),
              ),
              SizedBox(height: AppSpacing.spacingSm.h),
              Text(
                user.fullName,
                textAlign: TextAlign.center,
                style: AppTypography.h3(color: cs.onSurface),
              ),
              Text(
                overview.gradeLabel,
                textAlign: TextAlign.center,
                style: AppTypography.bodyLarge(color: cs.onSurfaceVariant),
              ),
              SizedBox(height: AppSpacing.spacingSm.h),
              DecoratedBox(
                decoration: BoxDecoration(
                  color: AppColors.brandPrimary500Alpha20,
                  borderRadius: BorderRadius.circular(AppRadius.radiusFull.r),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.spacingSm.w,
                    vertical: AppSpacing.spacingXs.h,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.flag_rounded,
                        size: 16.sp,
                        color: cs.onSurfaceVariant,
                      ),
                      SizedBox(width: AppSpacing.spacingXs.w),
                      Text(
                        'Level ${overview.level}',
                        style: AppTypography.labelSmall(
                          color: cs.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.spacing2xl.h),
          ProfileLevelProgressCard(
            formatThousands: formatThousands,
            nextLevel: overview.nextLevel,
            xpCurrent: overview.xpCurrent,
            xpGoal: overview.xpGoal,
            remainder: overview.xpToNextLevel,
          ),
          SizedBox(height: AppSpacing.spacing2xl.h),
          Row(
            children: [
              Expanded(
                child: ProfileStatColumnCard(
                  color: AppColors.brandSecondary500,
                  titleColor: AppColors.brandSecondary50,
                  subtitleColor: AppColors.brandSecondary100,
                  value: '${overview.streakDays}',
                  label: 'Day Streak',
                  svgAsset: 'assets/icons/fire_icon.svg',
                ),
              ),
              SizedBox(width: AppSpacing.spacingLg.w),
              Expanded(
                child: ProfileStatColumnCard(
                  color: AppColors.brandPrimary500,
                  titleColor: AppColors.brandPrimary50,
                  subtitleColor: AppColors.brandPrimary100,
                  value: formatThousands(overview.totalXp),
                  label: 'Total XP',
                  svgAsset: 'assets/icons/electric_icon.svg',
                ),
              ),
              SizedBox(width: AppSpacing.spacingLg.w),
              Expanded(
                child: ProfileStatColumnCard(
                  color: AppColors.success500,
                  titleColor: AppColors.success50,
                  subtitleColor: AppColors.success100,
                  value: '${overview.lessonsCompleted}',
                  label: 'Lessons',
                  svgAsset: 'assets/icons/book_icon.svg',
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.spacing2xl.h),
          ProfileParentsSection(parents: overview.linkedParents),
          SizedBox(height: AppSpacing.spacing2xl.h),
          ProfileRecentAchievementsSection(
            achievements: overview.recentAchievements,
          ),
        ],
      ),
    );
  }
}
