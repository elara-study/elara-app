import 'package:elara/config/routes.dart';
import 'package:elara/core/navigation/app_navigation.dart';
import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:elara/features/teacher/domain/group/entities/teacher_group_entity.dart';
import 'package:elara/features/teacher/presentation/dashboard/cubits/teacher_roadmaps_cubit.dart';
import 'package:elara/features/teacher/presentation/dashboard/cubits/teacher_roadmaps_state.dart';
import 'package:elara/shared/widgets/app_glass_header.dart';
import 'package:elara/shared/widgets/app_section_header.dart';
import 'package:elara/shared/widgets/create_group_dialog.dart';
import 'package:elara/shared/widgets/subject_group_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TeacherRoadmapsScreen extends StatelessWidget {
  const TeacherRoadmapsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      extendBodyBehindAppBar: true,
      appBar: const AppGlassHeader(title: 'Roadmaps'),
      body: BlocBuilder<TeacherRoadmapsCubit, TeacherRoadmapsState>(
        builder: (context, state) {
          return switch (state) {
            TeacherRoadmapsInitial() || TeacherRoadmapsLoading() =>
              const Center(child: CircularProgressIndicator()),
            TeacherRoadmapsError(:final message) => _ErrorView(
              message: message,
              onRetry: () =>
                  context.read<TeacherRoadmapsCubit>().loadRoadmaps(),
            ),
            TeacherRoadmapsLoaded(:final roadmaps) =>
              roadmaps.isEmpty
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
                            title: 'Learning Paths',
                            dialogConfig: const GroupDialogConfig(
                              title: 'Create a roadmap',
                              showRoadmapName: false,
                            ),
                            onCreateGroup: (title, subject, grade, _) {
                              context
                                  .read<TeacherRoadmapsCubit>()
                                  .createRoadmap(
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
                            itemCount: roadmaps.length,
                            separatorBuilder: (_, __) =>
                                SizedBox(height: AppSpacing.spacingLg.h),
                            itemBuilder: (_, index) =>
                                _buildRoadmapCard(roadmaps[index]),
                          ),
                        ],
                      ),
                    ),
          };
        },
      ),
    );
  }

  Widget _buildRoadmapCard(TeacherGroupEntity group) {
    return Builder(
      builder: (context) {
        return SubjectGroupCard(
          group: group,
          variant: SubjectGroupCardVariant.roadmap,
          onTap: () => AppNavigation.pushNamed(
            context,
            AppRoutes.teacherRoadmap,
            arguments: group,
          ),
        );
      },
    );
  }
}

// ── Create-group action button ────────────────────────────────────────────────

// class _CreateGroupButton extends StatelessWidget {
//   final VoidCallback onTap;

//   const _CreateGroupButton({required this.onTap});

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: EdgeInsets.symmetric(
//           horizontal: AppSpacing.spacingMd.w,
//           vertical: AppSpacing.spacingXs.h,
//         ),
//         decoration: BoxDecoration(
//           color: AppColors.brandPrimary500,
//           borderRadius: BorderRadius.circular(20.r),
//         ),
//         child: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             SvgPicture.asset(
//               'assets/icons/join_icon.svg',
//               width: 16.w,
//               height: 16.w,
//               colorFilter: const ColorFilter.mode(
//                 AppColors.white,
//                 BlendMode.srcIn,
//               ),
//             ),
//             SizedBox(width: AppSpacing.spacing2xs.w),
//             Text(
//               'Create',
//               style: AppTypography.labelRegular(
//                 color: AppColors.white,
//               ).copyWith(fontWeight: AppTypography.semiBold),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // ── Empty state ────────────────────────────────────────────────────────────────

class _EmptyGroupsView extends StatelessWidget {
  const _EmptyGroupsView();

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
              config: const GroupDialogConfig(
                title: 'Create a roadmap',
                showRoadmapName: false,
              ),
              onSubmit: (title, subject, grade, _) {
                context.read<TeacherRoadmapsCubit>().createRoadmap(
                  title: title,
                  subject: subject,
                  grade: grade,
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
                'No roadmaps yet',
                style: AppTypography.h6(color: cs.onSurface),
              ),
              SizedBox(height: 6.h),
              Text(
                'Tap Create to add your first roadmap.',
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
