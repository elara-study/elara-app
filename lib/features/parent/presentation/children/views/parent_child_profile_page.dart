import 'package:elara/config/dependency_injection.dart';
import 'package:elara/config/routes.dart';
import 'package:elara/core/navigation/app_navigation.dart';
import 'package:elara/features/parent/presentation/children/views/parent_child_insights_page.dart';
import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_radius.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:elara/features/parent/domain/home/entities/parent_child_progress_entity.dart';
import 'package:elara/features/parent/presentation/children/cubits/parent_child_profile_cubit.dart';
import 'package:elara/features/parent/presentation/children/cubits/parent_child_profile_state.dart';
import 'package:elara/features/teacher/presentation/group/widgets/teacher_student_insight_card.dart';
import 'package:elara/features/teacher/presentation/group/widgets/teacher_student_stats_grid.dart';
import 'package:elara/features/student/presentation/profile/widgets/profile_level_progress_card.dart';
import 'package:elara/shared/widgets/app_glass_header.dart';
import 'package:elara/shared/widgets/app_section_header.dart';
import 'package:elara/features/parent/presentation/children/widgets/parent_child_profile_overflow_menu.dart';
import 'package:elara/features/parent/presentation/children/widgets/parent_homework_card.dart';
import 'package:elara/features/parent/presentation/children/views/parent_child_homework_route_args.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Detailed child profile screen for Parents
/// Loaded completely via clean BLoC architecture through [ParentChildProfileCubit].
class ParentChildProfilePage extends StatelessWidget {
  const ParentChildProfilePage({super.key, required this.child});

  final ParentChildProgressEntity child;

  static String _formatThousands(int n) {
    final s = n.toString();
    if (s.length <= 3) return s;
    return '${s.substring(0, s.length - 3)},${s.substring(s.length - 3)}';
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ParentChildProfileCubit>(
      create: (_) => getIt<ParentChildProfileCubit>()..loadProfile(child.id),
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        extendBodyBehindAppBar: true,
        appBar: AppGlassHeader(
          title: child.handle,
          automaticallyImplyLeading: true,
          actions: [
            Padding(
              padding: EdgeInsets.only(right: AppSpacing.spacingSm.w),
              child: ParentChildProfileOverflowMenu(
                childName: child.displayName,
                childId: child.id,
              ),
            ),
          ],
        ),
        body: BlocBuilder<ParentChildProfileCubit, ParentChildProfileState>(
          builder: (context, state) {
            final theme = Theme.of(context);
            final cs = theme.colorScheme;

            return switch (state) {
              ParentChildProfileInitial() || ParentChildProfileLoading() =>
                const Center(child: CircularProgressIndicator()),
              ParentChildProfileError(:final message) => Center(
                child: Padding(
                  padding: EdgeInsets.all(AppSpacing.spacingLg.w),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        message,
                        textAlign: TextAlign.center,
                        style: AppTypography.bodyLarge(color: cs.onSurface),
                      ),
                      SizedBox(height: AppSpacing.spacingMd.h),
                      FilledButton(
                        onPressed: () => context
                            .read<ParentChildProfileCubit>()
                            .loadProfile(child.id),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              ),
              ParentChildProfileLoaded(:final profile) => SingleChildScrollView(
                padding: EdgeInsets.only(
                  left: AppSpacing.spacingLg.w,
                  right: AppSpacing.spacingLg.w,
                  top: kToolbarHeight + AppSpacing.spacing8xl.h,
                  bottom: AppSpacing.spacing5xl.h,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // ── Avatar & Basic Header Info ──────────────────────────────────
                    Column(
                      children: [
                        CircleAvatar(
                          radius: 39.r,
                          backgroundColor: cs.surfaceContainerHighest,
                          child: Text(
                            profile.child.displayName.isNotEmpty
                                ? profile.child.displayName[0].toUpperCase()
                                : '?',
                            style: AppTypography.h2(
                              color: cs.onSurface,
                            ).copyWith(fontWeight: FontWeight.w800),
                          ),
                        ),
                        SizedBox(height: AppSpacing.spacingSm.h),
                        Text(
                          profile.child.displayName,
                          textAlign: TextAlign.center,
                          style: AppTypography.h3(color: cs.onSurface),
                        ),
                        Text(
                          profile.child.gradeLabel.isNotEmpty
                              ? profile.child.gradeLabel
                              : 'Active Learner',
                          textAlign: TextAlign.center,
                          style: AppTypography.bodyLarge(
                            color: cs.onSurfaceVariant,
                          ),
                        ),
                        SizedBox(height: AppSpacing.spacingSm.h),
                        DecoratedBox(
                          decoration: BoxDecoration(
                            color: AppColors.brandPrimary500.withValues(
                              alpha: 0.15,
                            ),
                            borderRadius: BorderRadius.circular(
                              AppRadius.radiusFull.r,
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: AppSpacing.spacingSm.w,
                              vertical: AppSpacing.spacingXs.h,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SvgPicture.asset(
                                  'assets/icons/flag_icon.svg',
                                  width: 16.w,
                                  height: 16.w,
                                  colorFilter: ColorFilter.mode(
                                    cs.onSurfaceVariant,
                                    BlendMode.srcIn,
                                  ),
                                ),
                                SizedBox(width: AppSpacing.spacingXs.w),
                                Text(
                                  'Level ${profile.child.level}',
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

                    // ── Level Progress Card ──────────────────────────────────────────
                    ProfileLevelProgressCard(
                      formatThousands: _formatThousands,
                      nextLevel: profile.child.level + 1,
                      xpCurrent: profile.child.xpPoints,
                      xpGoal: profile.child.xpPoints + 1200,
                      remainder: 1200,
                    ),
                    SizedBox(height: AppSpacing.spacing2xl.h),

                    // ── Stats Grid ──────────────────────────────────────────────────
                    TeacherStudentStatsGrid(
                      totalXpDisplay: _formatThousands(profile.child.xpPoints),
                      lessonsLabel:
                          '${profile.child.currentLesson}/${profile.child.totalLessons}',
                      streakLabel: '${profile.child.streakDays} days',
                      attendanceLabel: profile.attendanceLabel,
                    ),
                    SizedBox(height: AppSpacing.spacing2xl.h),

                    // ── Received Teacher Insights Section ────────────────────────────
                    if (profile.insight != null) ...[
                      AppSectionHeader(
                        title: 'Insights',
                        onSeeAll: () {
                          AppNavigation.pushNamed(
                            context,
                            AppRoutes.parentChildInsights,
                            arguments: ParentChildInsightsRouteArgs(
                              childId: child.id,
                              childHandle: child.handle,
                            ),
                          );
                        },
                      ),
                      SizedBox(height: AppSpacing.spacingLg.h),
                      TeacherStudentInsightCard(
                        insight: profile.insight!,
                        onEdit: null,
                        onSend: null,
                      ),
                      SizedBox(height: AppSpacing.spacing2xl.h),
                    ],

                    // ── Homework Section ─────────────────────────────────────────────
                    if (profile.homeworks.isNotEmpty) ...[
                      AppSectionHeader(
                        title: 'Homework',
                        onSeeAll: () {
                          AppNavigation.pushNamed(
                            context,
                            AppRoutes.parentChildHomework,
                            arguments: ParentChildHomeworkRouteArgs(
                              childId: child.id,
                              childHandle: child.handle,
                            ),
                          );
                        },
                      ),
                      SizedBox(height: AppSpacing.spacingLg.h),
                      for (final hw in profile.homeworks.take(2)) ...[
                        ParentHomeworkCard(entity: hw),
                        SizedBox(height: AppSpacing.spacingLg.h),
                      ],
                    ],
                  ],
                ),
              ),
            };
          },
        ),
      ),
    );
  }
}
