import 'package:elara/config/dependency_injection.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:elara/features/student/homework/presentation/cubits/homework_cubit.dart';
import 'package:elara/features/student/homework/presentation/cubits/homework_state.dart';
import 'package:elara/features/student/homework/presentation/homework_route_args.dart';
import 'package:elara/features/student/homework/presentation/widgets/homework_overview_card.dart';
import 'package:elara/features/student/homework/presentation/widgets/homework_problem_card.dart';
import 'package:elara/shared/widgets/app_glass_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Full-screen homework assignment view.
///
/// Provides its own [HomeworkCubit] and loads the assignment on mount.
/// Navigation: pushed from [ModuleSheet] via [AppRoutes.homework].
class HomeworkScreen extends StatelessWidget {
  final String homeworkId;
  final String? groupId;
  final String? moduleId;

  const HomeworkScreen({
    super.key,
    required this.homeworkId,
    this.groupId,
    this.moduleId,
  });

  factory HomeworkScreen.fromArgs(HomeworkRouteArgs args) {
    return HomeworkScreen(
      homeworkId: args.homeworkId,
      groupId: args.groupId,
      moduleId: args.moduleId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeworkCubit>(
      create: (_) => getIt<HomeworkCubit>()
        ..loadHomework(
          homeworkId: homeworkId,
          groupId: groupId,
          moduleId: moduleId,
        ),
      child: BlocBuilder<HomeworkCubit, HomeworkState>(
        builder: (context, state) {
          final cs = Theme.of(context).colorScheme;

          return switch (state) {
            HomeworkInitial() || HomeworkLoading() => const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
            HomeworkError(:final message) => Scaffold(
              appBar: const AppGlassHeader(
                title: 'Homework',
                automaticallyImplyLeading: true,
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
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      SizedBox(height: AppSpacing.spacingXl.h),
                      TextButton(
                        onPressed: () =>
                            context.read<HomeworkCubit>().loadHomework(
                              homeworkId: homeworkId,
                              groupId: groupId,
                              moduleId: moduleId,
                            ),
                        child: const Text('Try again'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            HomeworkLoaded(:final homework) => Scaffold(
              extendBodyBehindAppBar: true,
              appBar: AppGlassHeader(
                title: 'Homework',
                subtitle: '${homework.subject} • ${homework.moduleTitle}',
                automaticallyImplyLeading: true,
              ),
              body: ListView(
                padding: EdgeInsets.only(
                  left: AppSpacing.spacingLg.w,
                  right: AppSpacing.spacingLg.w,
                  top: kToolbarHeight + 62.h,
                  bottom: AppSpacing.spacing2xl.h,
                ),
                children: [
                  HomeworkOverviewCard(
                    totalXp: homework.totalXp,
                    completedProblems: homework.completedProblems,
                    totalProblems: homework.totalProblems,
                    progressPercent: homework.progressPercent,
                  ),
                  SizedBox(height: AppSpacing.spacing2xl.h),

                  Text(
                    "Problem List",
                    style: AppTypography.h5(
                      color: cs.onSurface,
                    ).copyWith(fontWeight: AppTypography.extraBold),
                  ),
                  SizedBox(height: AppSpacing.spacing2xl.h),
                  ...homework.problems.map(
                    (problem) => Padding(
                      padding: EdgeInsets.only(bottom: AppSpacing.spacingLg.h),
                      child: HomeworkProblemCard(problem: problem),
                    ),
                  ),
                ],
              ),
            ),
            _ => const SizedBox.shrink(),
          };
        },
      ),
    );
  }
}
