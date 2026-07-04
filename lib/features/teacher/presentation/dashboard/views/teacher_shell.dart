import 'package:elara/config/dependency_injection.dart';
import 'package:elara/features/notifications/presentation/views/notifications_screen.dart';
import 'package:elara/features/teacher/presentation/dashboard/cubits/teacher_home_cubit.dart';
import 'package:elara/features/teacher/presentation/group/cubits/teacher_groups_cubit.dart';
import 'package:elara/features/teacher/presentation/roadmap/cubits/teacher_roadmaps_cubit.dart';
import 'package:elara/features/teacher/presentation/group/views/teacher_groups_screen.dart';
import 'package:elara/features/teacher/presentation/dashboard/views/teacher_home_screen.dart';
import 'package:elara/features/teacher/presentation/roadmap/views/teacher_roadmaps_screen.dart';
import 'package:elara/features/teacher/presentation/profile/cubits/teacher_profile_cubit.dart';
import 'package:elara/features/teacher/presentation/profile/views/teacher_profile_screen.dart';
import 'package:elara/shared/widgets/app_bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    NotificationsScreen(),
    TeacherProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<TeacherHomeCubit>(
          create: (_) => getIt<TeacherHomeCubit>()..loadHome(),
        ),
        BlocProvider<TeacherProfileCubit>(
          create: (_) => getIt<TeacherProfileCubit>()..loadProfile(),
        ),
        BlocProvider<TeacherGroupsCubit>(
          create: (_) => getIt<TeacherGroupsCubit>()..loadGroups(),
        ),
        BlocProvider<TeacherRoadmapsCubit>(
          create: (_) => getIt<TeacherRoadmapsCubit>()..loadRoadmaps(),
        ),
      ],
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
