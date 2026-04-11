import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:elara/features/student/domain/entities/student_group_entity.dart';
import 'package:elara/features/student/presentation/cubits/home/student_home_cubit.dart';
import 'package:elara/features/student/presentation/cubits/home/student_home_state.dart';
import 'package:elara/features/student/presentation/widgets/home/continue_learning_card.dart';
import 'package:elara/features/student/presentation/widgets/home/daily_goal_item.dart';
import 'package:elara/features/student/presentation/widgets/home/home_header.dart';
import 'package:elara/shared/widgets/app_action_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<StudentHomeCubit>().loadHome();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LightModeColors.surfaceApp,
      body: SafeArea(
        child: BlocBuilder<StudentHomeCubit, StudentHomeState>(
          builder: (context, state) {
            if (state is StudentHomeLoading || state is StudentHomeInitial) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (state is StudentHomeError) {
              return _ErrorView(
                message: state.message,
                onRetry: () =>
                    context.read<StudentHomeCubit>().loadHome(),
              );
            }

            if (state is StudentHomeLoaded) {
              return _HomeContent(state: state);
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

// ── Loaded content ────────────────────────────────────────────────────────────

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
    // Show max 2 groups on home screen
    final previewGroups = state.groups.take(2).toList();

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ──────────────────────────────────────────────────────
          HomeHeader(
            notificationCount: state.profile.notificationCount,
            points: state.profile.points,
          ),

          SizedBox(height: 20.h),

          // ── Greeting ─────────────────────────────────────────────────────
          Text(
            '$_greeting, ${state.profile.firstName}!',
            style: AppTypography.h4(color: LightModeColors.textPrimary),
          ),

          SizedBox(height: 2.h),

          Text(
            'Ready to continue your learning journey?',
            style: AppTypography.bodyMedium(
              color: LightModeColors.textSecondary,
            ),
          ),

          SizedBox(height: 20.h),

          // ── Continue Learning ────────────────────────────────────────────
          ContinueLearningCard(
            progress: state.continuelearning,
            onTap: () {
              // TODO: Navigate to lesson when lesson screens are built
            },
          ),

          SizedBox(height: 24.h),

          // ── Daily Goals ──────────────────────────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Daily Goals',
                style: AppTypography.h6(color: LightModeColors.textPrimary),
              ),
              Text(
                '${state.completedGoalsCount}/${state.dailyGoals.length} completed',
                style: AppTypography.bodySmall(
                  color: LightModeColors.textSecondary,
                ),
              ),
            ],
          ),

          SizedBox(height: 12.h),

          ...state.dailyGoals.map(
            (goal) => Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: DailyGoalItem(goal: goal),
            ),
          ),

          SizedBox(height: 12.h),

          // ── My Groups ────────────────────────────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'My Groups',
                style: AppTypography.h6(color: LightModeColors.textPrimary),
              ),
              GestureDetector(
                onTap: () {
                  // TODO: Switch to Learn tab — will be wired in Step 6
                },
                child: Row(
                  children: [
                    Text(
                      'See All',
                      style: AppTypography.bodySmall(
                        color: AppColors.brandPrimary500,
                      ).copyWith(fontWeight: FontWeight.w600),
                    ),
                    Icon(
                      Icons.chevron_right_rounded,
                      size: 16.sp,
                      color: AppColors.brandPrimary500,
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
                subtitle:
                    '${(group.progressPercent * 100).round()}% complete',
                icon: _iconForGroup(group),
                primaryColor: _primaryColor(group),
                secondaryColor: _secondaryColor(group),
                onTap: () {
                  // TODO: Navigate to group detail
                },
              ),
            ),
          ),

          SizedBox(height: 8.h),
        ],
      ),
    );
  }

  // ── Group helpers ─────────────────────────────────────────────────────────

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
      default: // 'blue'
        return AppColors.brandPrimary500;
    }
  }

  Color _secondaryColor(StudentGroupEntity group) {
    switch (group.colorKey) {
      case 'orange':
        return AppColors.brandSecondary400;
      case 'green':
        return AppColors.success400;
      default: // 'blue'
        return AppColors.brandPrimary400;
    }
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
