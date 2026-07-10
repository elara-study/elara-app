import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:elara/features/teacher/presentation/group/widgets/teacher_student_insight_card.dart';
import 'package:elara/config/dependency_injection.dart';
import 'package:elara/features/parent/presentation/children/cubits/parent_child_insights_cubit.dart';
import 'package:elara/features/parent/presentation/children/cubits/parent_child_insights_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:elara/shared/widgets/app_glass_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ParentChildInsightsRouteArgs {
  final String childId;
  final String childHandle;

  ParentChildInsightsRouteArgs({
    required this.childId,
    required this.childHandle,
  });
}

class ParentChildInsightsPage extends StatelessWidget {
  final ParentChildInsightsRouteArgs args;

  const ParentChildInsightsPage({super.key, required this.args});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return BlocProvider<ParentChildInsightsCubit>(
      create: (_) =>
          getIt<ParentChildInsightsCubit>()..loadInsights(args.childId),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppGlassHeader(title: 'Insights', subtitle: args.childHandle),
        body: BlocBuilder<ParentChildInsightsCubit, ParentChildInsightsState>(
          builder: (context, state) {
            if (state is ParentChildInsightsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ParentChildInsightsError) {
              return Center(child: Text(state.message));
            } else if (state is ParentChildInsightsLoaded) {
              final insights = state.insights;

              if (insights.isEmpty) {
                return Center(
                  child: Text(
                    'No insights yet.',
                    style: AppTypography.bodyMedium(color: cs.onSurfaceVariant),
                  ),
                );
              }

              return SingleChildScrollView(
                padding: EdgeInsets.only(
                  left: AppSpacing.spacingLg.w,
                  right: AppSpacing.spacingLg.w,
                  top: kToolbarHeight + AppSpacing.spacing8xl.h,
                  bottom: AppSpacing.spacing5xl.h,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: AppSpacing.spacingMd.h),
                      child: Text(
                        'Recent Insights',
                        style: AppTypography.h5(
                          color: cs.onSurface,
                        ).copyWith(fontWeight: FontWeight.w800),
                      ),
                    ),
                    ...insights.map(
                      (insight) => Padding(
                        padding: EdgeInsets.only(
                          bottom: AppSpacing.spacingLg.h,
                        ),
                        child: TeacherStudentInsightCard(
                          insight: insight,
                          onEdit: null,
                          onSend: null,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
