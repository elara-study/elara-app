import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:elara/features/parent/presentation/home/cubits/parent_home_cubit.dart';
import 'package:elara/features/parent/presentation/home/cubits/parent_home_state.dart';
import 'package:elara/features/parent/presentation/home/cubits/parent_tab_cubit.dart';
import 'package:elara/features/parent/presentation/home/widgets/parent_activity_tile.dart';
import 'package:elara/features/parent/presentation/home/widgets/parent_child_progress_card.dart';
import 'package:elara/features/parent/presentation/home/widgets/parent_stat_cards_row.dart';
import 'package:elara/shared/widgets/app_glass_header.dart';
import 'package:elara/shared/widgets/app_refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Parent dashboard home — matches Figma Elara parent Home (205:2146).
class ParentHomeScreen extends StatelessWidget {
  const ParentHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ParentHomeCubit, ParentHomeState>(
      builder: (context, state) {
        if (state is ParentHomeLoading || state is ParentHomeInitial) {
          return Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            body: const Center(child: CircularProgressIndicator()),
          );
        }
        if (state is ParentHomeError) {
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
                          context.read<ParentHomeCubit>().loadHome(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
        if (state is ParentHomeLoaded) {
          final overview = state.overview;
          final cs = Theme.of(context).colorScheme;
          return Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            extendBodyBehindAppBar: true,
            appBar: const AppGlassHeader(title: 'elara'),
            body: AppRefreshIndicator(
              onRefresh: () async {
                context.read<ParentHomeCubit>().loadHome();
              },
              child: SingleChildScrollView(
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
                    'Welcome back!',
                    style: AppTypography.h3(
                      color: cs.onSurface,
                    ).copyWith(fontWeight: AppTypography.black),
                  ),
                  SizedBox(height: AppSpacing.spacing2xs.h),
                  Text(
                    'Here’s how your children are doing',
                    style: AppTypography.bodyLarge(color: cs.onSurfaceVariant),
                  ),
                  SizedBox(height: AppSpacing.spacing2xl.h),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'My Children',
                          style: AppTypography.h4(color: cs.onSurface),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.only(
                            left: AppSpacing.spacingSm.w,
                          ),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          visualDensity: VisualDensity.compact,
                          foregroundColor: AppColors.brandPrimary500,
                        ),
                        onPressed: () =>
                            context.read<ParentTabCubit>().goToTab(1),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'See All',
                              style: AppTypography.labelMedium(
                                color: AppColors.brandPrimary500,
                              ),
                            ),
                            Icon(
                              Icons.keyboard_arrow_right_rounded,
                              color: AppColors.brandPrimary500,
                              size: 18.sp,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppSpacing.spacingLg.h),
                  for (final c in overview.children) ...[
                    ParentChildProgressCard(child: c),
                    SizedBox(height: AppSpacing.spacingMd.h),
                  ],
                  SizedBox(height: AppSpacing.spacingLg.h),
                  ParentStatCardsRow(stats: overview.stats),
                  SizedBox(height: AppSpacing.spacing2xl.h),
                  Text(
                    'Recent Activity',
                    style: AppTypography.h4(color: cs.onSurface),
                  ),
                  SizedBox(height: AppSpacing.spacingLg.h),
                  for (final a in overview.recentActivity) ...[
                    ParentActivityTile(activity: a),
                    SizedBox(height: AppSpacing.spacingMd.h),
                  ],
                ],
              ),
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
