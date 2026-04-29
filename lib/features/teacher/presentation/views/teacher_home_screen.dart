import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_radius.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:elara/features/student/rewards/presentation/widgets/achievement_stat_card.dart';
import 'package:elara/features/teacher/presentation/cubits/teacher_home_cubit.dart';
import 'package:elara/features/teacher/presentation/cubits/teacher_home_state.dart';
import 'package:elara/features/teacher/presentation/views/widgets/chat_with_elara.dart';
import 'package:elara/shared/widgets/app_action_card.dart';
import 'package:elara/shared/widgets/app_glass_header.dart';
import 'package:elara/shared/widgets/app_section_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:elara/core/utils/ui_helpers.dart';
import 'package:flutter_svg/svg.dart';

class TeacherHomeScreen extends StatelessWidget {
  const TeacherHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TeacherHomeCubit, TeacherHomeState>(
      builder: (context, state) {
        return switch (state) {
          TeacherHomeInitial() || TeacherHomeLoading() => Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            body: const Center(child: CircularProgressIndicator()),
          ),
          TeacherHomeError(:final message) => Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            appBar: const AppGlassHeader(title: 'elara'),
            body: _ErrorView(
              message: message,
              onRetry: () => context.read<TeacherHomeCubit>().loadHome(),
            ),
          ),
          TeacherHomeLoaded(
            :final profile,
            :final groups,
            :final recentActivity,
          ) =>
            Scaffold(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              extendBodyBehindAppBar: true,
              appBar: const AppGlassHeader(title: 'elara'),
              body: SingleChildScrollView(
                padding: EdgeInsets.only(
                  left: AppSpacing.spacingLg.w,
                  right: AppSpacing.spacingLg.w,
                  top: kToolbarHeight + 62.h,
                  bottom: 120.h,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Greeting ──────────────────────────────────────────
                    Text(
                      '${UiHelpers.getGreeting()}, prof. ${profile.firstName}!',
                      style:
                          AppTypography.h3(
                            color: Theme.of(context).colorScheme.onSurface,
                          ).copyWith(
                            fontWeight: AppTypography.black,
                            fontSize: 25.sp,
                          ),
                    ),
                    SizedBox(height: AppSpacing.spacing2xs.h),
                    Text(
                      'Ready to inspire today',
                      style: AppTypography.bodyLarge(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),

                    SizedBox(height: AppSpacing.spacing2xl.h),

                    // ── Chat with elara CTA ───────────────────────────────
                    ChatWithElaraCard(
                      onTap: () {
                        //  navigate to AI chat
                      },
                    ),

                    SizedBox(height: AppSpacing.spacing2xl.h),

                    // ── My Groups ─────────────────────────────────────────
                    AppSectionHeader(
                      title: 'My Groups',
                      onSeeAll: () {
                        //   navigate to Groups tab
                      },
                    ),
                    SizedBox(height: AppSpacing.spacingMd.h),
                    ...groups
                        .take(2)
                        .map(
                          (group) => Padding(
                            padding: EdgeInsets.only(
                              bottom: AppSpacing.spacingMd.h,
                            ),
                            child: AppActionCard(
                              title: group.name,
                              subtitle:
                                  '${group.studentCount} students • ${(group.progressPercent * 100).round()}% complete',
                              icon: Icons.groups_rounded,
                              primaryColor: UiHelpers.getGroupPrimaryColor(
                                group.colorKey,
                              ),
                              secondaryColor: UiHelpers.getGroupSecondaryColor(
                                group.colorKey,
                              ),
                              onTap: () {
                                //  navigate to group detail
                              },
                            ),
                          ),
                        ),
                    //my roadmaps
                    AppSectionHeader(
                      title: 'My Roadmaps',
                      onSeeAll: () {
                        // navigate to Groups tab
                      },
                    ),
                    SizedBox(height: AppSpacing.spacingMd.h),
                    ...groups
                        .take(2)
                        .map(
                          (group) => Padding(
                            padding: EdgeInsets.only(
                              bottom: AppSpacing.spacingMd.h,
                            ),
                            child: AppActionCard(
                              title: group.name,
                              subtitle:
                                  '${group.studentCount} students • ${(group.progressPercent * 100).round()}% complete',
                              icon: Icons.groups_rounded,
                              primaryColor: UiHelpers.getGroupPrimaryColor(
                                group.colorKey,
                              ),
                              secondaryColor: UiHelpers.getGroupSecondaryColor(
                                group.colorKey,
                              ),
                              onTap: () {
                                // navigate to group detail
                              },
                            ),
                          ),
                        ),

                    SizedBox(height: AppSpacing.spacing2xl.h),

                    // ── Stats row ─────────────────────────────────────────
                    IntrinsicHeight(
                      child: Row(
                        children: [
                          Expanded(
                            child: AchievementStatCard(
                              value: '${profile.activeStudentCount}',
                              label: 'Active Students',
                              svgAsset: 'assets/icons/graduation_cap_icon.svg',
                              cardColor: AppColors.brandPrimary600,
                              iconBgColor: AppColors.brandPrimary700,
                              textColor: AppColors.brandPrimary100,
                            ),
                          ),
                          SizedBox(width: AppSpacing.spacingMd.w),
                          Expanded(
                            child: AchievementStatCard(
                              value:
                                  '${(profile.avgCompletion * 100).round()}%',
                              label: 'Avg. Completion',
                              svgAsset: 'assets/icons/flag_icon.svg',
                              cardColor: AppColors.brandSecondary600,
                              iconBgColor: AppColors.brandSecondary700,
                              textColor: AppColors.brandSecondary100,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: AppSpacing.spacing2xl.h),

                    // ── Recent Activity ───────────────────────────────────
                    const AppSectionHeader(title: 'Recent Activity'),
                    SizedBox(height: AppSpacing.spacingSm.h),
                    _ActivityCard(activities: recentActivity),
                  ],
                ),
              ),
            ),
        };
      },
    );
  }
}

// ── Activity card ─────────────────────────────────────────────────────────────
class _ActivityCard extends StatelessWidget {
  final List activities;

  const _ActivityCard({required this.activities});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      children: activities.map((a) {
        return Padding(
          padding: EdgeInsets.only(bottom: AppSpacing.spacingMd.h),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.spacingLg.w,
              vertical: AppSpacing.spacingLg.h,
            ),
            decoration: BoxDecoration(
              color: cs.surface,
              borderRadius: BorderRadius.circular(AppRadius.radiusLg.r),
              boxShadow: [
                BoxShadow(
                  color: cs.shadow.withValues(alpha: 0.06),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Notification icon with light grey circular background
                Container(
                  width: 44.w,
                  height: 44.w,
                  decoration: BoxDecoration(
                    color: cs.surfaceContainerHighest,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      'assets/icons/alerts_icon_filled.svg',
                      width: 20.w,
                      height: 20.w,
                      colorFilter: ColorFilter.mode(
                        cs.primary,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: AppSpacing.spacingMd.w),
                // Title + subtitle
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        a.title,
                        style: AppTypography.labelRegular(
                          color: cs.onSurface,
                        ).copyWith(fontWeight: AppTypography.bold),
                      ),
                      Text(
                        a.subtitle,
                        style: AppTypography.bodySmall(color: cs.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
                // Timestamp
                Text(
                  a.timeAgo,
                  style: AppTypography.caption(color: cs.onSurfaceVariant),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
// ── Error view ────────────────────────────────────────────────────────────────

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
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
              message,
              style: AppTypography.bodyMedium(color: cs.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppSpacing.spacingXl.h),
            TextButton(
              onPressed: onRetry,
              child: Text(
                'Try again',
                style: AppTypography.button(color: AppColors.brandPrimary500),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
