import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:elara/features/parent/presentation/reports/cubits/parent_reports_cubit.dart';
import 'package:elara/features/parent/presentation/reports/cubits/parent_reports_state.dart';
import 'package:elara/features/parent/presentation/reports/widgets/parent_insight_card.dart';
import 'package:elara/shared/widgets/app_glass_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Parent Reports tab — Figma frame Reports (1467:10103).
class ParentReportsScreen extends StatelessWidget {
  const ParentReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ParentReportsCubit, ParentReportsState>(
      builder: (context, state) {
        if (state is ParentReportsLoading || state is ParentReportsInitial) {
          return Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            body: const Center(child: CircularProgressIndicator()),
          );
        }
        if (state is ParentReportsError) {
          return Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            body: Center(
              child: Padding(
                padding: EdgeInsets.all(AppSpacing.spacingLg.w),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(state.message, textAlign: TextAlign.center),
                    SizedBox(height: AppSpacing.spacingMd.h),
                    FilledButton(
                      onPressed: () =>
                          context.read<ParentReportsCubit>().loadReports(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
        if (state is ParentReportsLoaded) {
          final cs = Theme.of(context).colorScheme;
          return Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            extendBodyBehindAppBar: true,
            appBar: AppGlassHeader(
              title: 'Reports',
              titleStyle:
                  AppTypography.h5(
                    font: AppTypography.comfortaa,
                    color: cs.onSurface,
                  ).copyWith(
                    fontSize: 20.sp,
                    height: 28 / 20,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            body: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.spacingLg.w,
                kToolbarHeight + 54.h + AppSpacing.spacing2xl.h,
                AppSpacing.spacingLg.w,
                120.h,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Recent Insights',
                    style: AppTypography.h3(
                      color: cs.onSurface,
                    ).copyWith(fontWeight: AppTypography.black),
                  ),
                  SizedBox(height: AppSpacing.spacingXs.h),
                  Text(
                    'Track progress and learning milestones',
                    style: AppTypography.bodyLarge(color: cs.onSurfaceVariant),
                  ),
                  SizedBox(height: AppSpacing.spacing2xl.h),
                  for (var i = 0; i < state.overview.insights.length; i++) ...[
                    ParentInsightCard(insight: state.overview.insights[i]),
                    if (i < state.overview.insights.length - 1)
                      SizedBox(height: AppSpacing.spacingLg.h),
                  ],
                ],
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
