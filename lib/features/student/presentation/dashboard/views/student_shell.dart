import 'dart:async';
import 'package:elara/config/dependency_injection.dart';
import 'package:elara/features/notifications/presentation/views/notifications_screen.dart';
import 'package:elara/features/student/domain/rewards/entities/badge_entity.dart';
import 'package:elara/features/student/presentation/dashboard/cubits/home/student_home_cubit.dart';
import 'package:elara/features/student/presentation/dashboard/cubits/learn/student_learn_cubit.dart';
import 'package:elara/features/student/presentation/dashboard/cubits/tab/student_tab_cubit.dart';
import 'package:elara/features/student/presentation/profile/cubits/student_profile_cubit.dart';
import 'package:elara/features/student/presentation/dashboard/views/home_screen.dart';
import 'package:elara/features/student/presentation/dashboard/views/learn_screen.dart';
import 'package:elara/features/student/presentation/rewards/cubits/rewards_cubit.dart';
import 'package:elara/features/student/presentation/rewards/widgets/badge_celebration_overlay.dart';
import 'package:elara/features/student/presentation/profile/views/student_profile_screen.dart';
import 'package:elara/features/student/presentation/rewards/views/rewards_screen.dart';
import 'package:elara/shared/widgets/app_bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Root shell for the Student dashboard.
///
/// Provides [StudentTabCubit], [StudentHomeCubit] and [StudentLearnCubit]
/// scoped to this shell. Any descendant can call
/// `context.read<StudentTabCubit>().goToLearn()` to switch tabs.
class StudentShell extends StatefulWidget {
  const StudentShell({super.key});

  @override
  State<StudentShell> createState() => _StudentShellState();
}

class _StudentShellState extends State<StudentShell> {
  StreamSubscription<BadgeEntity>? _badgeSubscription;
  BadgeEntity? _celebratingBadge;
  final List<BadgeEntity> _celebrationQueue = [];

  static const List<Widget> _pages = [
    HomeScreen(),
    LearnScreen(),
    RewardsScreen(),
    NotificationsScreen(),
    StudentProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    // Listen to badge unlocked events
    _badgeSubscription = getIt<RewardsCubit>().badgeUnlockedStream.listen((badge) {
      if (mounted) {
        setState(() {
          _celebrationQueue.add(badge);
          _celebratingBadge ??= _celebrationQueue.first;
        });
      }
    });
  }

  @override
  void dispose() {
    _badgeSubscription?.cancel();
    super.dispose();
  }

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
        BlocProvider<StudentProfileCubit>(
          create: (_) => getIt<StudentProfileCubit>()..loadProfile(),
        ),
      ],
      child: BlocBuilder<StudentTabCubit, int>(
        builder: (context, currentTab) {
          return Scaffold(
            extendBody: true,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            body: Stack(
              children: [
                IndexedStack(index: currentTab, children: _pages),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: AppBottomNavBar(
                    currentIndex: currentTab,
                    onTap: (i) => context.read<StudentTabCubit>().goToTab(i),
                  ),
                ),
                if (_celebratingBadge != null)
                  Positioned.fill(
                    child: BadgeCelebrationOverlay(
                      badge: _celebratingBadge!,
                      onDismiss: () {
                        setState(() {
                          if (_celebrationQueue.isNotEmpty) {
                            _celebrationQueue.removeAt(0);
                          }
                          _celebratingBadge = _celebrationQueue.isNotEmpty
                              ? _celebrationQueue.first
                              : null;
                        });
                      },
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
