import 'package:elara/core/theme/app_radius.dart';
import 'package:elara/features/student/presentation/cubits/tab/student_tab_cubit.dart';
import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:elara/features/student/domain/entities/student_group_entity.dart';
import 'package:elara/features/student/presentation/cubits/home/student_home_cubit.dart';
import 'package:elara/features/student/presentation/cubits/home/student_home_state.dart';
import 'package:elara/features/student/presentation/widgets/home/continue_learning_card.dart';
import 'package:elara/features/student/presentation/widgets/home/daily_goal_item.dart';
import 'package:elara/features/student/presentation/widgets/home/home_header.dart';
import 'package:elara/shared/widgets/app_action_card.dart';
import 'package:elara/shared/widgets/app_glass_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StudentHomeCubit, StudentHomeState>(
      builder: (context, state) {
        if (state is StudentHomeLoading || state is StudentHomeInitial) {
          return const Scaffold(
            backgroundColor: LightModeColors.surfacePrimary,
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (state is StudentHomeError) {
          return Scaffold(
            backgroundColor: LightModeColors.surfacePrimary,
            body: _ErrorView(
              message: state.message,
              onRetry: () => context.read<StudentHomeCubit>().loadHome(),
            ),
          );
        }
        if (state is StudentHomeLoaded) {
          return Scaffold(
            backgroundColor: LightModeColors.surfacePrimary,
            extendBodyBehindAppBar: true,
            appBar: AppGlassHeader(
              title: HomeHeader(
                notificationCount: state.profile.notificationCount,
                points: state.profile.points,
              ),
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

  String get _greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  @override
  Widget build(BuildContext context) {
    final previewGroups = state.groups.take(2).toList();

    return SingleChildScrollView(
      padding: EdgeInsets.only(
        left: 16.w,
        right: 16.w,
        top: kToolbarHeight + 62.h,
        bottom: 120.h,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //SizedBox(height: 20.h),
          Text(
            '$_greeting, ${state.profile.firstName}!',
            style: AppTypography.h3(
              color: LightModeColors.textPrimary,
            ).copyWith(fontWeight: AppTypography.black, fontSize: 25.sp),
          ),

          SizedBox(height: 2.h),

          Text(
            'Ready to continue your learning journey?',
            style: AppTypography.bodyLarge(
              color: LightModeColors.textSecondary,
            ),
          ),

          SizedBox(height: 24.h),

          ContinueLearningCard(
            progress: state.continuelearning,
            onTap: () {
              //  Navigate to lesson
            },
          ),

          SizedBox(height: 24.h),

          // ── Daily Goals ──────────────────────────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Daily Goals',
                style: AppTypography.h4(
                  color: LightModeColors.textPrimary,
                ).copyWith(fontWeight: FontWeight.w900),
              ),
              Text(
                '${state.completedGoalsCount}/${state.dailyGoals.length} completed',
                style: AppTypography.bodyMedium(
                  color: LightModeColors.textSecondary,
                ),
              ),
            ],
          ),

          SizedBox(height: 16.h),

          // All goals inside one white card
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: LightModeColors.surfacePrimary,
              borderRadius: BorderRadius.circular(AppRadius.radiusLg.r),
              boxShadow: [
                BoxShadow(
                  color: AppColors.neutral900.withValues(alpha: 0.1),
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

          SizedBox(height: 24.h),

          // ── My Groups ────────────────────────────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'My Groups',
                style: AppTypography.h4(
                  color: LightModeColors.textPrimary,
                ).copyWith(fontWeight: FontWeight.w900),
              ),
              GestureDetector(
                onTap: () => context.read<StudentTabCubit>().goToLearn(),
                child: Row(
                  children: [
                    Text(
                      'See All',
                      style: AppTypography.labelSmall(
                        color: ButtonColors.ghostText,
                      ),
                    ),
                    SvgPicture.asset(
                      'assets/icons/right_arrow_ios.svg',
                      width: 16.w,
                      height: 16.w,
                      colorFilter: const ColorFilter.mode(
                        ButtonColors.ghostText,
                        BlendMode.srcIn,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 12.h),

          ...previewGroups.map(
            (group) => Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: AppActionCard(
                title: group.name,
                subtitle: '${(group.progressPercent * 100).round()}% complete',
                icon: _iconForGroup(group),
                primaryColor: _primaryColor(group),
                secondaryColor: _secondaryColor(group),
                onTap: () {},
              ),
            ),
          ),

          SizedBox(height: 8.h),
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

  Color _primaryColor(StudentGroupEntity group) {
    switch (group.colorKey) {
      case 'orange':
        return AppColors.brandSecondary500;
      case 'green':
        return AppColors.success500;
      default:
        return AppColors.brandPrimary500;
    }
  }

  Color _secondaryColor(StudentGroupEntity group) {
    switch (group.colorKey) {
      case 'orange':
        return AppColors.brandSecondary400;
      case 'green':
        return AppColors.success400;
      default:
        return AppColors.brandPrimary400;
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
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.wifi_off_rounded,
              size: 48.sp,
              color: AppColors.neutral300,
            ),
            SizedBox(height: 16.h),
            Text(
              message,
              style: AppTypography.bodyMedium(
                color: LightModeColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20.h),
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
