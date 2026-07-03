import 'dart:async';
import 'package:elara/config/dependency_injection.dart';
import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_typography.dart';
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
    _ComingSoonPage(label: 'Alerts'),
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

// ── Coming soon placeholder for future tabs ───────────────────────────────────

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
