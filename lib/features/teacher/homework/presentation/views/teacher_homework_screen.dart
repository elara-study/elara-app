import 'package:elara/config/dependency_injection.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:elara/features/teacher/homework/domain/entities/teacher_homework_entity.dart';
import 'package:elara/features/teacher/homework/presentation/cubits/teacher_homework_cubit.dart';
import 'package:elara/features/teacher/homework/presentation/route_args/teacher_module_route_args.dart';
import 'package:elara/shared/widgets/assignment_overview_card.dart';
import 'package:elara/features/teacher/homework/presentation/widgets/teacher_problem_list_tab.dart';
import 'package:elara/features/teacher/homework/presentation/widgets/teacher_rated_tab.dart';
import 'package:elara/features/teacher/homework/presentation/widgets/teacher_submissions_tab.dart';
import 'package:elara/shared/widgets/app_glass_header.dart';
import 'package:elara/shared/widgets/pill_tab_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Teacher homework management screen for a specific module.
///
/// Provides its own [TeacherHomeworkCubit] and loads on mount.
/// Pushed via [AppRoutes.teacherModuleHomework].
class TeacherHomeworkScreen extends StatelessWidget {
  final String moduleId;
  final String moduleTitle;
  final String moduleLabel;
  final String groupId;
  final String subject;

  const TeacherHomeworkScreen({
    super.key,
    required this.moduleId,
    required this.moduleTitle,
    required this.moduleLabel,
    required this.groupId,
    required this.subject,
  });

  factory TeacherHomeworkScreen.fromArgs(TeacherModuleRouteArgs args) =>
      TeacherHomeworkScreen(
        moduleId: args.moduleId,
        moduleTitle: args.moduleTitle,
        moduleLabel: args.moduleLabel,
        groupId: args.groupId,
        subject: args.subject,
      );

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TeacherHomeworkCubit>(
      create: (_) =>
          getIt<TeacherHomeworkCubit>()
            ..load(moduleId: moduleId, groupId: groupId),
      child: BlocBuilder<TeacherHomeworkCubit, TeacherHomeworkState>(
        builder: (context, state) => switch (state) {
          TeacherHomeworkInitial() || TeacherHomeworkLoading() => Scaffold(
            appBar: AppGlassHeader(
              title: 'Homework',
              subtitle: '$subject • $moduleTitle',
            ),
            body: const Center(child: CircularProgressIndicator()),
          ),
          TeacherHomeworkError(:final message) => Scaffold(
            appBar: AppGlassHeader(
              title: 'Homework',
              subtitle: '$subject • $moduleTitle',
            ),
            body: Center(
              child: Padding(
                padding: EdgeInsets.all(AppSpacing.spacing2xl.w),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.wifi_off_rounded,
                      size: 48.sp,
                      color: Theme.of(context).colorScheme.outline,
                    ),
                    SizedBox(height: AppSpacing.spacingLg.h),
                    Text(
                      message,
                      textAlign: TextAlign.center,
                      style: AppTypography.bodyMedium(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: AppSpacing.spacingXl.h),
                    TextButton(
                      onPressed: () => context
                          .read<TeacherHomeworkCubit>()
                          .load(moduleId: moduleId, groupId: groupId),
                      child: const Text('Try again'),
                    ),
                  ],
                ),
              ),
            ),
          ),
          TeacherHomeworkLoaded(:final homework) => _HomeworkView(
            homework: homework,
          ),
        },
      ),
    );
  }
}

// ── Loaded view ───────────────────────────────────────────────────────────────

class _HomeworkView extends StatelessWidget {
  final TeacherHomeworkEntity homework;
  const _HomeworkView({required this.homework});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppGlassHeader(
          title: 'Homework',
          subtitle: '${homework.subject} • ${homework.moduleTitle}',
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: MediaQuery.of(context).padding.top + kToolbarHeight + 1,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.spacingLg.w,
                vertical: AppSpacing.spacingMd.h,
              ),
              child: AssignmentOverviewCard(totalXp: homework.totalXp),
            ),
            PillTabBar(
              tabs: const [
                Tab(text: 'Problem List'),
                Tab(text: 'Submissions'),
                Tab(text: 'Rated'),
              ],
              padding: EdgeInsets.fromLTRB(
                AppSpacing.spacingLg.w,
                AppSpacing.spacingMd.h,
                AppSpacing.spacingLg.w,
                AppSpacing.spacingLg.h,
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  TeacherProblemListTab(problems: homework.problems),
                  TeacherSubmissionsTab(
                    submissions: homework.submissions,
                    totalXp: homework.totalXp,
                  ),
                  TeacherRatedTab(ratedStudents: homework.ratedStudents),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
