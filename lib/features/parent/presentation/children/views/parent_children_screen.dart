import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:elara/features/parent/presentation/children/cubits/parent_children_cubit.dart';
import 'package:elara/features/parent/presentation/children/cubits/parent_children_state.dart';
import 'package:elara/config/routes.dart';
import 'package:elara/core/navigation/app_navigation.dart';
import 'package:elara/features/parent/presentation/children/widgets/parent_child_dashboard_card.dart';
import 'package:elara/features/parent/presentation/children/widgets/parent_add_child_sheet.dart';
import 'package:elara/features/parent/presentation/children/widgets/parent_children_page_header.dart';
import 'package:elara/features/parent/presentation/children/widgets/parent_pending_request_card.dart';
import 'package:elara/shared/widgets/app_glass_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Parent **Children** tab
class ParentChildrenScreen extends StatelessWidget {
  const ParentChildrenScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ParentChildrenCubit, ParentChildrenState>(
      builder: (context, state) {
        final theme = Theme.of(context);
        if (state is ParentChildrenLoading || state is ParentChildrenInitial) {
          return Scaffold(
            backgroundColor: theme.scaffoldBackgroundColor,
            body: Center(
              child: CircularProgressIndicator(
                color: theme.colorScheme.primary,
              ),
            ),
          );
        }
        if (state is ParentChildrenError) {
          return Scaffold(
            backgroundColor: theme.scaffoldBackgroundColor,
            body: Center(
              child: Padding(
                padding: EdgeInsets.all(AppSpacing.spacingLg.w),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: AppTypography.bodyLarge(
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: AppSpacing.spacingMd.h),
                    FilledButton(
                      onPressed: () =>
                          context.read<ParentChildrenCubit>().loadChildren(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
        if (state is ParentChildrenLoaded) {
          final d = state.dashboard;
          final cs = theme.colorScheme;
          return Scaffold(
            backgroundColor: theme.scaffoldBackgroundColor,
            extendBodyBehindAppBar: true,
            appBar: AppGlassHeader(
              title: 'Children',
              titleStyle:
                  AppTypography.h4(
                    font: AppTypography.comfortaa,
                    color: cs.onSurface,
                  ).copyWith(
                    fontSize: 24.sp,
                    height: 32 / 24,
                    fontWeight: FontWeight.w800,
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
                  ParentChildrenPageHeader(
                    onAddPressed: () => showParentAddChildSheet(
                      context,
                      context.read<ParentChildrenCubit>(),
                    ),
                  ),
                  SizedBox(height: AppSpacing.spacing2xl.h),
                  if (d.pendingRequests.isNotEmpty) ...[
                    _PendingRequestsHeading(colorScheme: cs),
                    SizedBox(height: AppSpacing.spacingLg.h),
                    for (final p in d.pendingRequests) ...[
                      ParentPendingRequestCard(
                        request: p,
                        onDecline: () => context
                            .read<ParentChildrenCubit>()
                            .respondToPendingRequest(p.id, false),
                        onAccept: () => context
                            .read<ParentChildrenCubit>()
                            .respondToPendingRequest(p.id, true),
                      ),
                      SizedBox(height: AppSpacing.spacingMd.h),
                    ],
                    SizedBox(height: AppSpacing.spacingLg.h),
                  ],
                  if (d.children.isEmpty && d.pendingRequests.isEmpty)
                    _ChildrenEmptyState(colorScheme: cs)
                  else
                    for (var i = 0; i < d.children.length; i++) ...[
                      ParentChildDashboardCard(
                        child: d.children[i],
                        onOpenDetail: () async {
                          final unlinked = await AppNavigation.pushNamed(
                            context,
                            AppRoutes.parentChildProfile,
                            arguments: d.children[i],
                          );
                          if (unlinked == true && context.mounted) {
                            context.read<ParentChildrenCubit>().loadChildren();
                          }
                        },
                      ),
                      if (i < d.children.length - 1)
                        SizedBox(height: AppSpacing.spacingMd.h),
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

class _PendingRequestsHeading extends StatelessWidget {
  const _PendingRequestsHeading({required this.colorScheme});

  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.people_outline_rounded,
          size: 22.sp,
          color: colorScheme.onSurface,
        ),
        SizedBox(width: AppSpacing.spacingSm.w),
        Text(
          'Pending Requests',
          style: AppTypography.h5(
            color: colorScheme.onSurface,
          ).copyWith(fontWeight: FontWeight.w800),
        ),
      ],
    );
  }
}

class _ChildrenEmptyState extends StatelessWidget {
  const _ChildrenEmptyState({required this.colorScheme});

  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSpacing.spacing2xl.h),
      child: Center(
        child: Text(
          'No linked children yet.',
          textAlign: TextAlign.center,
          style: AppTypography.bodyLarge(color: colorScheme.onSurfaceVariant),
        ),
      ),
    );
  }
}
