import 'package:elara/features/student/group/presentation/cubits/student_group_cubit.dart';
import 'package:elara/features/student/group/presentation/widgets/announcements/announcements_tab.dart';
import 'package:elara/features/student/group/presentation/widgets/group_progress_card.dart';
import 'package:elara/features/student/group/presentation/widgets/leaderboard_tab.dart';
import 'package:elara/features/student/group/presentation/widgets/roadmap/tab/roadmap_tab.dart';
import 'package:elara/features/student/group/presentation/widgets/student_group_app_bar_title.dart';
import 'package:elara/features/student/group/presentation/widgets/student_group_overflow_menu.dart';
import 'package:elara/features/student/group/presentation/widgets/student_tab_bar.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Student group shell: app bar, progress card, segmented tabs, tab bodies.
/// Data loading is triggered from [StudentGroupPage] (BlocProvider + Cubit).
class StudentGroupScreen extends StatelessWidget {
  const StudentGroupScreen({super.key});

  static const _tabs = [
    Tab(text: 'Leaderboard'),
    Tab(text: 'Roadmap'),
    Tab(text: 'Announcements'),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DefaultTabController(
      length: _tabs.length,
      child: Scaffold(
        appBar: AppBar(
          forceMaterialTransparency: true,
          elevation: 0,
          scrolledUnderElevation: 0,
          shadowColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          backgroundColor: Colors.transparent,
          foregroundColor: theme.colorScheme.onSurface,
          iconTheme: IconThemeData(color: theme.colorScheme.onSurface),
          centerTitle: false,
          titleSpacing: 0,
          title: BlocBuilder<StudentGroupCubit, StudentGroupState>(
            buildWhen: (prev, next) => prev.overview != next.overview,
            builder: (context, state) {
              final o = state.overview;
              return StudentGroupAppBarTitle(
                title: o?.courseTitle ?? '…',
                subtitle: o?.courseSubtitle ?? '',
              );
            },
          ),
          actions: [
            BlocBuilder<StudentGroupCubit, StudentGroupState>(
              buildWhen: (prev, next) =>
                  prev.overview?.courseTitle != next.overview?.courseTitle,
              builder: (context, state) {
                final title = state.overview?.courseTitle ?? 'this group';
                return StudentGroupOverflowMenu(courseTitle: title);
              },
            ),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Divider(
              height: 1,
              thickness: 1,
              color:
                  theme.dividerTheme.color ?? theme.colorScheme.outlineVariant,
            ),
          ),
        ),
        body: BlocBuilder<StudentGroupCubit, StudentGroupState>(
          builder: (context, state) {
            final o = state.overview;
            final loaded =
                state.status == StudentGroupStatus.loaded && o != null;
            final completed = o?.completedLessons ?? 0;
            final rawTotal = o?.totalLessons ?? 1;
            final total = rawTotal > 0 ? rawTotal : 1;
            final progress = loaded ? (completed / total).clamp(0.0, 1.0) : 0.0;

            return Column(
              children: [
                const SizedBox(height: AppSpacing.spacingLg),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.spacingLg,
                  ),
                  child: GroupProgressCard(
                    completedLabel: loaded
                        ? 'Lesson $completed of $total'
                        : 'Lesson …',
                    progress: progress,
                  ),
                ),
                const SizedBox(height: AppSpacing.spacingLg),
                const StudentTabBar(tabs: _tabs),
                const Expanded(
                  child: TabBarView(
                    children: [
                      LeaderboardTab(),
                      RoadmapTab(),
                      AnnouncementsTab(),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
