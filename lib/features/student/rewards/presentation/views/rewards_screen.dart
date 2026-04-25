import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:elara/features/student/rewards/domain/entities/badge_entity.dart';
import 'package:elara/features/student/rewards/domain/entities/leaderboard_entry_entity.dart';
import 'package:elara/features/student/rewards/domain/entities/rewards_profile_entity.dart';
import 'package:elara/features/student/rewards/presentation/cubits/rewards_cubit.dart';
import 'package:elara/features/student/rewards/presentation/cubits/rewards_state.dart';
import 'package:elara/features/student/rewards/presentation/widgets/achievement_stat_card.dart';
import 'package:elara/features/student/rewards/presentation/widgets/badge_card.dart';
import 'package:elara/features/student/rewards/presentation/widgets/leaderboard_entry_tile.dart';
import 'package:elara/features/student/rewards/presentation/widgets/rewards_tab_selector.dart';
import 'package:elara/shared/widgets/app_glass_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RewardsScreen extends StatelessWidget {
  const RewardsScreen({super.key});

  // Shared XP formatter: 1250 → "1,250"
  static String _fmt(int n) {
    final s = n.toString();
    if (s.length <= 3) return s;
    return '${s.substring(0, s.length - 3)},${s.substring(s.length - 3)}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      extendBodyBehindAppBar: true,
      appBar: const AppGlassHeader(title: 'Rewards'),
      body: BlocBuilder<RewardsCubit, RewardsState>(
        builder: (context, state) {
          if (state is RewardsInitial || state is RewardsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is RewardsError) {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(AppSpacing.spacing2xl.w),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.wifi_off_rounded,
                      size: 48.sp,
                      color: AppColors.neutral300,
                    ),
                    SizedBox(height: AppSpacing.spacingLg.h),
                    Text(
                      state.message,
                      style: AppTypography.bodyMedium(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: AppSpacing.spacingXl.h),
                    TextButton(
                      onPressed: () =>
                          context.read<RewardsCubit>().loadRewards(),
                      child: Text(
                        'Try again',
                        style: AppTypography.button(
                          color: AppColors.brandPrimary500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is RewardsLoaded) {
            return SingleChildScrollView(
              padding: EdgeInsets.only(
                left: AppSpacing.spacingLg.w,
                right: AppSpacing.spacingLg.w,
                top: kToolbarHeight + 62.h,
                bottom: 120.w,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _AchievementsCard(profile: state.profile, fmt: _fmt),
                  SizedBox(height: AppSpacing.spacing2xl.h),
                  RewardsTabSelector(activeTab: state.activeTab),
                  SizedBox(height: AppSpacing.spacingLg.h),
                  if (state.activeTab == 0)
                    _BadgesGrid(badges: state.badges)
                  else
                    _LeaderboardList(entries: state.leaderboard),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

//  Achievements header card

class _AchievementsCard extends StatelessWidget {
  final RewardsProfileEntity profile;
  final String Function(int) fmt;

  const _AchievementsCard({required this.profile, required this.fmt});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Achievements',
          style: AppTypography.h3(
            color: Theme.of(context).colorScheme.onSurface,
          ).copyWith(fontWeight: AppTypography.black),
        ),
        Text(
          'Track your progress and rewards',
          style: AppTypography.bodyLarge(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        SizedBox(height: AppSpacing.spacing2xl.h),

        // Row 1: XP + Lessons
        Row(
          children: [
            Expanded(
              child: AchievementStatCard(
                value: fmt(profile.totalXp),
                label: 'Total XP',
                svgAsset: 'assets/icons/electric_icon.svg',
                cardColor: AppColors.brandPrimary500,
                iconBgColor: AppColors.brandPrimary200,
                textColor: AppColors.brandPrimary100,
              ),
            ),
            SizedBox(width: AppSpacing.spacingMd.w),
            Expanded(
              child: AchievementStatCard(
                value: '${profile.lessonsCompleted}',
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

        //  Streak + Badges
        Row(
          children: [
            Expanded(
              child: AchievementStatCard(
                value: '${profile.streakDays} days',
                label: 'Streak',
                svgAsset: 'assets/icons/fire_icon.svg',
                cardColor: AppColors.brandSecondary500,
                iconBgColor: AppColors.brandSecondary200,
                textColor: AppColors.brandSecondary100,
              ),
            ),
            SizedBox(width: AppSpacing.spacingMd.w),
            Expanded(
              child: AchievementStatCard(
                value: profile.badgesLabel,
                label: 'Badges',
                svgAsset: 'assets/icons/rewards_icon_filled.svg',
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

// Badges  -column grid

class _BadgesGrid extends StatelessWidget {
  final List<BadgeEntity> badges;

  const _BadgesGrid({required this.badges});

  @override
  Widget build(BuildContext context) {
    final rows = <Widget>[];

    for (int i = 0; i < badges.length; i += 2) {
      final right = i + 1 < badges.length ? badges[i + 1] : null;

      rows.add(
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: BadgeCard(badge: badges[i])),
              if (right != null) ...[
                SizedBox(width: AppSpacing.spacingMd.w),
                Expanded(child: BadgeCard(badge: right)),
              ] else
                const Expanded(child: SizedBox.shrink()),
            ],
          ),
        ),
      );

      if (i + 2 < badges.length) {
        rows.add(SizedBox(height: AppSpacing.spacingMd.h));
      }
    }

    return Column(children: rows);
  }
}

//  Leaderboard list

class _LeaderboardList extends StatelessWidget {
  final List<LeaderboardEntryEntity> entries;

  const _LeaderboardList({required this.entries});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (int i = 0; i < entries.length; i++) ...[
          LeaderboardEntryTile(entry: entries[i]),
          if (i < entries.length - 1) SizedBox(height: AppSpacing.spacingMd.h),
        ],
      ],
    );
  }
}
