import 'package:elara/config/dependency_injection.dart';
import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:elara/features/student/presentation/cubits/home/student_home_cubit.dart';
import 'package:elara/features/student/presentation/cubits/learn/student_learn_cubit.dart';
import 'package:elara/features/student/presentation/cubits/tab/student_tab_cubit.dart';
import 'package:elara/features/student/presentation/views/home_screen.dart';
import 'package:elara/features/student/presentation/views/learn_screen.dart';
import 'package:elara/features/student/rewards/presentation/cubits/rewards_cubit.dart';
import 'package:elara/features/student/rewards/presentation/views/rewards_screen.dart';
import 'package:elara/shared/widgets/app_bottom_nav_bar.dart';
import 'package:elara/shared/widgets/app_glass_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:elara/core/theme/app_spacing.dart';

/// Root shell for the Student dashboard.
///
/// Provides [StudentTabCubit], [StudentHomeCubit] and [StudentLearnCubit]
/// scoped to this shell. Any descendant can call
/// `context.read<StudentTabCubit>().goToLearn()` to switch tabs.
class StudentShell extends StatelessWidget {
  const StudentShell({super.key});

  static const List<Widget> _pages = [
    HomeScreen(),
    LearnScreen(),
    RewardsScreen(),
    _ComingSoonPage(label: 'Alerts'),
    _ComingSoonPage(label: 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<StudentTabCubit>(create: (_) => getIt<StudentTabCubit>()),
        BlocProvider<StudentHomeCubit>(
          create: (_) => getIt<StudentHomeCubit>()..loadHome(),
        ),
        BlocProvider<StudentLearnCubit>(
          create: (_) => getIt<StudentLearnCubit>()..loadGroups(),
        ),
        BlocProvider<RewardsCubit>(
          create: (_) => getIt<RewardsCubit>()..loadRewards(),
        ),
      ],
      child: BlocBuilder<StudentTabCubit, int>(
        builder: (context, currentTab) {
          return Scaffold(
            extendBody: true,
            backgroundColor: LightModeColors.surfaceApp,
            body: IndexedStack(index: currentTab, children: _pages),
            bottomNavigationBar: AppBottomNavBar(
              currentIndex: currentTab,
              onTap: (i) => context.read<StudentTabCubit>().goToTab(i),
            ),
          );
        },
      ),
    );
  }
}

// ── Coming soon placeholder for future tabs ───────────────────────────────────

class _ComingSoonPage extends StatelessWidget {
  final String label;

  const _ComingSoonPage({required this.label});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LightModeColors.surfaceApp,
      extendBodyBehindAppBar: true,
      appBar: AppGlassHeader(title: label),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.construction_rounded,
              size: 48.sp,
              color: AppColors.neutral300,
            ),
            SizedBox(height: AppSpacing.spacingMd.h),
            Text(
              label,
              style: AppTypography.h5(color: LightModeColors.textPrimary),
            ),
            SizedBox(height: 6.h),
            Text(
              'Coming soon',
              style: AppTypography.bodyMedium(
                color: LightModeColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
