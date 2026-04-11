import 'package:elara/config/dependency_injection.dart';
import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:elara/features/student/presentation/cubits/home/student_home_cubit.dart';
import 'package:elara/features/student/presentation/cubits/learn/student_learn_cubit.dart';
import 'package:elara/shared/widgets/app_bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Root shell for the Student dashboard.
///
/// Hosts 5 tabs in an [IndexedStack] so state is preserved when switching tabs.
/// Provides [StudentHomeCubit] and [StudentLearnCubit] scoped to this shell.
class StudentShell extends StatefulWidget {
  const StudentShell({super.key});

  @override
  State<StudentShell> createState() => _StudentShellState();
}

class _StudentShellState extends State<StudentShell> {
  int _currentIndex = 0;

  // Placeholder pages for tabs not yet implemented
  static const List<Widget> _pages = [
    _HomePagePlaceholder(),
    _LearnPagePlaceholder(),
    _ComingSoonPage(label: 'Rewards'),
    _ComingSoonPage(label: 'Alerts'),
    _ComingSoonPage(label: 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<StudentHomeCubit>(
          create: (_) => getIt<StudentHomeCubit>(),
        ),
        BlocProvider<StudentLearnCubit>(
          create: (_) => getIt<StudentLearnCubit>(),
        ),
      ],
      child: Scaffold(
        backgroundColor: LightModeColors.surfaceApp,
        body: IndexedStack(index: _currentIndex, children: _pages),
        bottomNavigationBar: AppBottomNavBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
        ),
      ),
    );
  }
}

// ── Placeholder wrappers —

class _HomePagePlaceholder extends StatelessWidget {
  const _HomePagePlaceholder();

  @override
  Widget build(BuildContext context) =>
      const Center(child: Text('Home — Step 5'));
}

class _LearnPagePlaceholder extends StatelessWidget {
  const _LearnPagePlaceholder();

  @override
  Widget build(BuildContext context) =>
      const Center(child: Text('Learn — Step 6'));
}

/// Generic "Coming soon" placeholder shown for tabs not yet implemented.
class _ComingSoonPage extends StatelessWidget {
  final String label;

  const _ComingSoonPage({required this.label});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LightModeColors.surfaceApp,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.construction_rounded,
              size: 48.sp,
              color: AppColors.neutral300,
            ),
            SizedBox(height: 12.h),
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
