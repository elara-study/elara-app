import 'package:elara/config/dependency_injection.dart';
import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:elara/features/teacher/presentation/cubits/teacher_home_cubit.dart';
import 'package:elara/features/teacher/presentation/views/teacher_groups_screen.dart';
import 'package:elara/features/teacher/presentation/views/teacher_home_screen.dart';
import 'package:elara/features/teacher/presentation/views/teacher_roadmaps_screen.dart';
import 'package:elara/shared/widgets/app_bottom_nav_bar.dart';
import 'package:elara/shared/widgets/app_glass_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:elara/core/theme/app_spacing.dart';

class TeacherShell extends StatefulWidget {
  const TeacherShell({super.key});

  @override
  State<TeacherShell> createState() => _TeacherShellState();
}

class _TeacherShellState extends State<TeacherShell> {
  int _currentTab = 0;

  static const List<Widget> _pages = [
    TeacherHomeScreen(),
    TeacherGroupsScreen(),
    TeacherRoadmapsScreen(),
    _ComingSoonPage(label: 'Alerts'),
    _ComingSoonPage(label: 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TeacherHomeCubit>(
      create: (_) => getIt<TeacherHomeCubit>()..loadHome(),
      child: Scaffold(
        extendBody: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Stack(
          children: [
            IndexedStack(index: _currentTab, children: _pages),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: AppBottomNavBar(
                tabs: AppBottomNavBar.teacherTabs,
                currentIndex: _currentTab,
                onTap: (i) => setState(() => _currentTab = i),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Coming soon placeholder ───────────────────────────────────────────────────

class _ComingSoonPage extends StatelessWidget {
  final String label;

  const _ComingSoonPage({required this.label});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
            Text(label, style: AppTypography.h5(color: cs.onSurface)),
            SizedBox(height: 6.h),
            Text(
              'Coming soon',
              style: AppTypography.bodyMedium(color: cs.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}
