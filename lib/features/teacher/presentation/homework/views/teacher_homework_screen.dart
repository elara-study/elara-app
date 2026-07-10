import 'package:elara/config/dependency_injection.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:elara/features/teacher/domain/homework/entities/teacher_homework_entity.dart';
import 'package:elara/features/teacher/presentation/homework/cubits/teacher_homework_cubit.dart';
import 'package:elara/features/teacher/presentation/homework/route_args/teacher_module_route_args.dart';
import 'package:elara/shared/widgets/assignment_overview_card.dart';
import 'package:elara/features/teacher/presentation/homework/widgets/teacher_problem_list_tab.dart';
import 'package:elara/features/teacher/presentation/homework/widgets/teacher_rated_tab.dart';
import 'package:elara/features/teacher/presentation/homework/widgets/teacher_submissions_tab.dart';
import 'package:elara/shared/widgets/app_glass_header.dart';
import 'package:elara/shared/widgets/pill_tab_bar.dart';
import 'package:elara/core/localization/localization_extension.dart';
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
              title: context.l10n.teacherHomeworkLabel,
              subtitle: '$subject • $moduleTitle',
            ),
            body: const Center(child: CircularProgressIndicator()),
          ),
          TeacherHomeworkError(:final message, :final errorType) => Scaffold(
            appBar: AppGlassHeader(
              title: context.l10n.teacherHomeworkLabel,
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
                      message
                          ?? switch (errorType) {
                            TeacherHomeworkErrorType.add => context.l10n.teacherFailedAddProblem,
                            TeacherHomeworkErrorType.update => context.l10n.teacherFailedUpdateProblem,
                            TeacherHomeworkErrorType.delete => context.l10n.teacherFailedDeleteProblem,
                            null => context.l10n.teacherFailedAddProblem,
                          },
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
                      child: Text(context.l10n.commonTryAgain),
                    ),
                  ],
                ),
              ),
            ),
          ),
          TeacherHomeworkLoaded(:final homework) => _HomeworkView(
            homework: homework,
            fallbackSubject: subject,
            fallbackModuleTitle: moduleTitle,
            fallbackModuleId: moduleId,
            fallbackGroupId: groupId,
          ),
        },
      ),
    );
  }
}

// ── Loaded view ───────────────────────────────────────────────────────────────

class _HomeworkView extends StatelessWidget {
  final TeacherHomeworkEntity homework;
  final String fallbackSubject;
  final String fallbackModuleTitle;
  final String fallbackModuleId;
  final String fallbackGroupId;

  const _HomeworkView({
    required this.homework,
    required this.fallbackSubject,
    required this.fallbackModuleTitle,
    required this.fallbackModuleId,
    required this.fallbackGroupId,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppGlassHeader(
          title: context.l10n.teacherHomeworkLabel,
          subtitle:
              '${homework.subject.isEmpty ? fallbackSubject : homework.subject} • '
              '${homework.moduleTitle.isEmpty ? fallbackModuleTitle : homework.moduleTitle}',
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
              tabs: [
                Tab(text: context.l10n.teacherProblemList),
                Tab(text: context.l10n.teacherSubmissions),
                Tab(text: context.l10n.teacherRatedTab),
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
                  TeacherProblemListTab(
                    problems: homework.problems,
                    onAddProblem: (description) =>
                        context.read<TeacherHomeworkCubit>().addProblem(
                          moduleId: homework.moduleId.isEmpty
                              ? fallbackModuleId
                              : homework.moduleId,
                          groupId: homework.groupId.isEmpty
                              ? fallbackGroupId
                              : homework.groupId,
                          description: description,
                        ),
                    onUpdateProblem:
                        ({required problemId, required description}) =>
                            context.read<TeacherHomeworkCubit>().updateProblem(
                              moduleId: homework.moduleId.isEmpty
                                  ? fallbackModuleId
                                  : homework.moduleId,
                              groupId: homework.groupId.isEmpty
                                  ? fallbackGroupId
                                  : homework.groupId,
                              problemId: problemId,
                              description: description,
                            ),
                    onDeleteProblem: (problemId) =>
                        context.read<TeacherHomeworkCubit>().deleteProblem(
                          moduleId: homework.moduleId.isEmpty
                              ? fallbackModuleId
                              : homework.moduleId,
                          groupId: homework.groupId.isEmpty
                              ? fallbackGroupId
                              : homework.groupId,
                          problemId: problemId,
                        ),
                  ),
                  TeacherSubmissionsTab(
                    submissions: homework.submissions,
                    totalXp: homework.totalXp,
                    moduleId: homework.moduleId.isEmpty
                        ? fallbackModuleId
                        : homework.moduleId,
                    groupId: homework.groupId.isEmpty
                        ? fallbackGroupId
                        : homework.groupId,
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
