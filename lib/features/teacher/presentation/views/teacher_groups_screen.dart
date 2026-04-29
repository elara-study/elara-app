import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:elara/features/teacher/domain/entities/teacher_group_entity.dart';
import 'package:elara/features/teacher/presentation/cubits/teacher_home_cubit.dart';
import 'package:elara/features/teacher/presentation/cubits/teacher_home_state.dart';
import 'package:elara/shared/widgets/app_glass_header.dart';
import 'package:elara/shared/widgets/app_section_header.dart';
import 'package:elara/shared/widgets/subject_group_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TeacherGroupsScreen extends StatelessWidget {
  const TeacherGroupsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      extendBodyBehindAppBar: true,
      appBar: const AppGlassHeader(title: 'Groups'),
      body: BlocBuilder<TeacherHomeCubit, TeacherHomeState>(
        builder: (context, state) {
          return switch (state) {
            TeacherHomeInitial() || TeacherHomeLoading() => const Center(
              child: CircularProgressIndicator(),
            ),
            TeacherHomeError(:final message) => _ErrorView(
              message: message,
              onRetry: () => context.read<TeacherHomeCubit>().loadHome(),
            ),
            TeacherHomeLoaded(:final groups) =>
              groups.isEmpty
                  ? const _EmptyGroupsView()
                  : SingleChildScrollView(
                      padding: EdgeInsets.only(
                        left: AppSpacing.spacingLg.w,
                        right: AppSpacing.spacingLg.w,
                        top: kToolbarHeight + 62.h,
                        bottom: 120.h,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Page subtitle
                          AppSectionHeader(
                            title: 'My Groups',
                            onCreateGroup: (title, subject, grade) {
                              context.read<TeacherHomeCubit>().createGroup(
                                title: title,
                                subject: subject,
                                grade: grade,
                              );
                            },
                          ),
                          SizedBox(height: AppSpacing.spacing2xl.h),

                          // Group cards
                          ListView.separated(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            itemCount: groups.length,
                            separatorBuilder: (_, __) =>
                                SizedBox(height: AppSpacing.spacingLg.h),
                            itemBuilder: (_, index) =>
                                _buildGroupCard(groups[index]),
                          ),
                        ],
                      ),
                    ),
          };
        },
      ),
    );
  }

  Widget _buildGroupCard(TeacherGroupEntity group) {
    return SubjectGroupCard(
      group: group,
      variant: SubjectGroupCardVariant.teacher,
    );
  }
}

// // ── Empty state ────────────────────────────────────────────────────────────────

class _EmptyGroupsView extends StatelessWidget {
  const _EmptyGroupsView();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.spacing2xl.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.groups_outlined,
              size: 52.sp,
              color: AppColors.neutral300,
            ),
            SizedBox(height: AppSpacing.spacingMd.h),
            Text('No groups yet', style: AppTypography.h6(color: cs.onSurface)),
            SizedBox(height: 6.h),
            Text(
              'Tap Create to add your first class.',
              style: AppTypography.bodySmall(color: cs.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Error view ─────────────────────────────────────────────────────────────────

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.spacing2xl.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.wifi_off_rounded,
              size: 48.sp,
              color: AppColors.neutral300,
            ),
            SizedBox(height: AppSpacing.spacingLg.h),
            Text(
              message,
              style: AppTypography.bodyMedium(color: cs.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppSpacing.spacingXl.h),
            TextButton(
              onPressed: onRetry,
              child: Text(
                'Try again',
                style: AppTypography.button(color: AppColors.brandPrimary500),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
