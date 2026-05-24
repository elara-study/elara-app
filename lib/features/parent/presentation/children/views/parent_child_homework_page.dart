import 'package:elara/config/dependency_injection.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:elara/features/parent/presentation/children/cubits/parent_child_homework_cubit.dart';
import 'package:elara/features/parent/presentation/children/cubits/parent_child_homework_state.dart';
import 'package:elara/features/parent/presentation/children/views/parent_child_homework_route_args.dart';
import 'package:elara/features/parent/presentation/children/widgets/parent_homework_card.dart';
import 'package:elara/features/parent/presentation/children/widgets/parent_homework_stat_row.dart';
import 'package:elara/shared/widgets/app_glass_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Full-screen homework list for a child, navigated from the
/// "See All" button in the parent child profile homework section.
///
/// Provides its own [ParentChildHomeworkCubit] and loads on mount.
/// Pushed via [AppRoutes.parentChildHomework].
class ParentChildHomeworkPage extends StatelessWidget {
  const ParentChildHomeworkPage({
    super.key,
    required this.childId,
    required this.childHandle,
  });

  final String childId;
  final String childHandle;

  /// Convenience constructor from route args.
  factory ParentChildHomeworkPage.fromArgs(ParentChildHomeworkRouteArgs args) =>
      ParentChildHomeworkPage(
        childId: args.childId,
        childHandle: args.childHandle,
      );

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ParentChildHomeworkCubit>(
      create: (_) => getIt<ParentChildHomeworkCubit>()..loadHomeworks(childId),
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        extendBodyBehindAppBar: true,
        appBar: AppGlassHeader(
          title: 'Homework',
          subtitle: childHandle,
          automaticallyImplyLeading: true,
        ),
        body: BlocBuilder<ParentChildHomeworkCubit, ParentChildHomeworkState>(
          builder: (context, state) {
            final theme = Theme.of(context);
            final cs = theme.colorScheme;

            return switch (state) {
              ParentChildHomeworkInitial() || ParentChildHomeworkLoading() =>
                const Center(child: CircularProgressIndicator()),
              ParentChildHomeworkError(:final message) => Center(
                child: Padding(
                  padding: EdgeInsets.all(AppSpacing.spacingLg.w),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        message,
                        textAlign: TextAlign.center,
                        style: AppTypography.bodyLarge(color: cs.onSurface),
                      ),
                      SizedBox(height: AppSpacing.spacingMd.h),
                      FilledButton(
                        onPressed: () => context
                            .read<ParentChildHomeworkCubit>()
                            .loadHomeworks(childId),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              ),
              ParentChildHomeworkLoaded(
                :final homeworks,
                :final totalCount,
                :final submittedCount,
                :final gradedCount,
              ) =>
                SingleChildScrollView(
                  padding: EdgeInsets.only(
                    left: AppSpacing.spacingLg.w,
                    right: AppSpacing.spacingLg.w,
                    top: kToolbarHeight + AppSpacing.spacing8xl.h,
                    bottom: AppSpacing.spacing5xl.h,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // ── Stat Tiles Row ──────────────────────────────────
                      ParentHomeworkStatRow(
                        total: totalCount,
                        submitted: submittedCount,
                        graded: gradedCount,
                      ),
                      SizedBox(height: AppSpacing.spacing3xl.h),

                      // ── "Homework List" Header ──────────────────────────
                      Text(
                        'Homework List',
                        style: AppTypography.h4(
                          color: cs.onSurface,
                        ).copyWith(fontWeight: FontWeight.w900),
                      ),
                      SizedBox(height: AppSpacing.spacingLg.h),

                      // ── Homework Cards ──────────────────────────────────
                      for (final hw in homeworks) ...[
                        ParentHomeworkCard(entity: hw),
                        SizedBox(height: AppSpacing.spacingLg.h),
                      ],
                    ],
                  ),
                ),
            };
          },
        ),
      ),
    );
  }
}
