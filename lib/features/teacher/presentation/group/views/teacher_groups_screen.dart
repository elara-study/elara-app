import 'package:elara/config/routes.dart';
import 'package:elara/core/navigation/app_navigation.dart';
import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:elara/features/teacher/domain/group/entities/teacher_group_entity.dart';
import 'package:elara/features/teacher/presentation/group/cubits/teacher_groups_cubit.dart';
import 'package:elara/features/teacher/presentation/group/cubits/teacher_groups_state.dart';
import 'package:elara/features/teacher/presentation/roadmap/cubits/teacher_roadmaps_cubit.dart';
import 'package:elara/features/teacher/presentation/roadmap/cubits/teacher_roadmaps_state.dart';
import 'package:elara/shared/widgets/app_glass_header.dart';
import 'package:elara/shared/widgets/app_section_header.dart';
import 'package:elara/shared/widgets/create_group_dialog.dart';
import 'package:elara/shared/widgets/subject_group_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:elara/core/localization/localization_extension.dart';

class TeacherGroupsScreen extends StatelessWidget {
  const TeacherGroupsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      extendBodyBehindAppBar: true,
      appBar: AppGlassHeader(title: context.l10n.teacherGroupsAppBar),
      body: Builder(
        builder: (context) {
          final roadmapsState = context.watch<TeacherRoadmapsCubit>().state;
          final availableRoadmaps = roadmapsState is TeacherRoadmapsLoaded
              ? roadmapsState.roadmaps.map((r) => r.name).toList()
              : <String>[];

          return BlocBuilder<TeacherGroupsCubit, TeacherGroupsState>(
            builder: (context, state) {
              return switch (state) {
                TeacherGroupsInitial() || TeacherGroupsLoading() =>
                  const Center(child: CircularProgressIndicator()),
                TeacherGroupsError(:final message) => _ErrorView(
                  message: message,
                  onRetry: () =>
                      context.read<TeacherGroupsCubit>().loadGroups(),
                ),
                TeacherGroupsLoaded(:final groups) =>
                  groups.isEmpty
                      ? _EmptyGroupsView(roadmaps: availableRoadmaps)
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
                                title: context.l10n.teacherGroupsTitle,
                                dialogConfig: GroupDialogConfig(
                                  roadmaps: availableRoadmaps,
                                ),
                                onCreateGroup:
                                    (title, subject, grade, roadmapName) {
                                      context
                                          .read<TeacherGroupsCubit>()
                                          .createGroup(
                                            title: title,
                                            subject: subject,
                                            grade: grade,
                                            roadmapName: roadmapName,
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
          );
        },
      ),
    );
  }

  Widget _buildGroupCard(TeacherGroupEntity group) {
    return Builder(
      builder: (context) => SubjectGroupCard(
        group: group,
        variant: SubjectGroupCardVariant.teacher,
        onTap: () async {
          await AppNavigation.pushNamed(
            context,
            AppRoutes.teacherGroup,
            arguments: group,
          );
          if (context.mounted) {
            context.read<TeacherGroupsCubit>().loadGroups();
          }
        },
      ),
    );
  }
}

// // ── Empty state ────────────────────────────────────────────────────────────────

class _EmptyGroupsView extends StatelessWidget {
  final List<String> roadmaps;
  const _EmptyGroupsView({required this.roadmaps});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.spacing2xl.w),
        child: GestureDetector(
          onTap: () {
            GroupDialog.show(
              context,
              config: GroupDialogConfig(roadmaps: roadmaps),
              onSubmit: (title, subject, grade, roadmapName) {
                context.read<TeacherGroupsCubit>().createGroup(
                  title: title,
                  subject: subject,
                  grade: grade,
                  roadmapName: roadmapName,
                );
              },
            );
          },
          behavior: HitTestBehavior.opaque,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.groups_outlined,
                size: 52.sp,
                color: AppColors.neutral300,
              ),
              SizedBox(height: AppSpacing.spacingMd.h),
              Text(
                context.l10n.teacherNoGroups,
                style: AppTypography.h6(color: cs.onSurface),
              ),
              SizedBox(height: 6.h),
              Text(
                context.l10n.teacherTapCreateFirstClass,
                style: AppTypography.bodySmall(color: cs.onSurfaceVariant),
                textAlign: TextAlign.center,
              ),
            ],
          ),
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
                context.l10n.commonTryAgain,
                style: AppTypography.button(color: AppColors.brandPrimary500),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
