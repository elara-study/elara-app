import 'package:elara/core/theme/app_radius.dart';
import 'package:elara/features/student/presentation/cubits/tab/student_tab_cubit.dart';
import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:elara/features/student/domain/entities/student_group_entity.dart';
import 'package:elara/features/student/presentation/cubits/home/student_home_cubit.dart';
import 'package:elara/features/student/presentation/cubits/home/student_home_state.dart';
import 'package:elara/features/student/presentation/widgets/home/continue_learning_card.dart';
import 'package:elara/features/student/presentation/widgets/home/daily_goal_item.dart';
import 'package:elara/shared/widgets/app_action_card.dart';
import 'package:elara/shared/widgets/app_glass_header.dart';
import 'package:elara/shared/widgets/app_section_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/core/utils/ui_helpers.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StudentHomeCubit, StudentHomeState>(
      builder: (context, state) {
        if (state is StudentHomeLoading || state is StudentHomeInitial) {
          return Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            body: const Center(child: CircularProgressIndicator()),
          );
        }
        if (state is StudentHomeError) {
          return Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            body: _ErrorView(
              message: state.message,
              onRetry: () => context.read<StudentHomeCubit>().loadHome(),
            ),
          );
        }
        if (state is StudentHomeLoaded) {
          return Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            extendBodyBehindAppBar: true,
            appBar: AppGlassHeader(
              title: 'elara',
              actions: [
                _HeaderChip(
                  iconAsset: 'assets/icons/fire_icon.svg',
                  label: '${state.profile.notificationCount}',
                  color: AppColors.brandSecondary500,
                ),
                SizedBox(width: AppSpacing.spacingSm.w),
                _HeaderChip(
                  iconAsset: 'assets/icons/rewards_icon.svg',
                  label: '${state.profile.points}',
                  color: AppColors.brandPrimary500,
                ),
                SizedBox(width: AppSpacing.spacingLg.w),
              ],
            ),
            body: _HomeContent(state: state),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

// ── Loaded content

class _HomeContent extends StatelessWidget {
  final StudentHomeLoaded state;

  const _HomeContent({required this.state});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final previewGroups = state.groups.take(2).toList();

    return SingleChildScrollView(
      padding: EdgeInsets.only(
        left: AppSpacing.spacingLg.w,
        right: AppSpacing.spacingLg.w,
        top: kToolbarHeight + 62.h,
        bottom: 120.w,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //SizedBox(height: AppSpacing.spacingXl.h),
          Text(
            '${UiHelpers.getGreeting()}, ${state.profile.firstName}!',
            style: AppTypography.h3(
              color: cs.onSurface,
            ).copyWith(fontWeight: AppTypography.black, fontSize: 25.sp),
          ),

          SizedBox(height: AppSpacing.spacing2xs.h),

          Text(
            'Ready to continue your learning journey?',
            style: AppTypography.bodyLarge(
              color: cs.onSurfaceVariant,
            ),
          ),

          SizedBox(height: AppSpacing.spacing2xl.h),

          ContinueLearningCard(
            progress: state.continuelearning,
            onTap: () {
              //  Navigate to lesson
            },
          ),

          SizedBox(height: AppSpacing.spacing2xl.h),

          // ── Daily Goals ──────────────────────────────────────────────────
          AppSectionHeader(
            title: 'Daily Goals',
            seeAllLabel:
                '${state.completedGoalsCount}/${state.dailyGoals.length} completed',
          ),

          SizedBox(height: AppSpacing.spacingLg.h),

          // All goals inside one white card
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(AppSpacing.spacingLg.w),
            decoration: BoxDecoration(
              color: cs.surface,
              borderRadius: BorderRadius.circular(AppRadius.radiusLg.r),
              boxShadow: [
                BoxShadow(
                  color: cs.shadow.withValues(alpha: 0.12),
                  blurRadius: 12,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                for (int i = 0; i < state.dailyGoals.length; i++) ...[
                  DailyGoalItem(
                    goal: state.dailyGoals[i],
                    progressPercent: _goalProgress(i),
                  ),
                ],
              ],
            ),
          ),

          SizedBox(height: AppSpacing.spacing2xl.h),

          // ── My Groups ────────────────────────────────────────────────────
          AppSectionHeader(
            title: 'My Groups',
            onSeeAll: () => context.read<StudentTabCubit>().goToLearn(),
          ),

          SizedBox(height: AppSpacing.spacingMd.h),

          ...previewGroups.map(
            (group) => Padding(
              padding: EdgeInsets.only(bottom: AppSpacing.spacingMd.h),
              child: AppActionCard(
                title: group.name,
                subtitle: '${(group.progressPercent * 100).round()}% complete',
                icon: _iconForGroup(group),
                primaryColor: UiHelpers.getGroupPrimaryColor(group.colorKey),
                secondaryColor: UiHelpers.getGroupSecondaryColor(group.colorKey),
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/student-group',
                    arguments: group.id,
                  );
                },
              ),
            ),
          ),

          SizedBox(height: AppSpacing.spacingSm.h),
        ],
      ),
    );
  }

  IconData _iconForGroup(StudentGroupEntity group) {
    switch (group.subject.toLowerCase()) {
      case 'mathematics':
        return Icons.calculate_outlined;
      case 'science':
        return Icons.science_outlined;
      case 'english':
        return Icons.menu_book_outlined;
      default:
        return Icons.groups_outlined;
    }
  }

  /// Mock per-goal progress until the API provides real values.
  /// TODO: replace with entity.progressPercent when backend adds it.
  double _goalProgress(int index) {
    const values = [0.75, 1.0, 0.40];
    return values[index % values.length];
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
              style: AppTypography.bodyMedium(
                color: cs.onSurfaceVariant,
              ),
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

class _HeaderChip extends StatelessWidget {
  final String iconAsset;
  final String label;
  final Color color;

  const _HeaderChip({
    required this.iconAsset,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.spacingMd.w,
        vertical: AppSpacing.spacingSm.h,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadius.radiusFull),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            iconAsset,
            width: 10.w,
            height: 13.w,
            colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
          ),
          SizedBox(width: AppSpacing.spacingXs.w),
          Text(label, style: AppTypography.labelRegular(color: color)),
        ],
      ),
    );
  }
}
