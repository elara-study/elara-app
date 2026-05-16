import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_radius.dart';
import 'package:elara/core/theme/app_shadows.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:elara/features/student/group/domain/entities/group_roadmap.dart';
import 'package:elara/features/student/group/presentation/cubits/roadmap_cubit.dart';
import 'package:elara/shared/widgets/announcement_form_content.dart';
import 'package:elara/shared/widgets/app_dialog.dart';
import 'package:elara/shared/widgets/app_overflow_menu.dart';
import 'package:elara/shared/widgets/app_section_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TeacherRoadmapTab extends StatelessWidget {
  const TeacherRoadmapTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RoadmapCubit, RoadmapState>(
      builder: (context, state) {
        return switch (state.status) {
          RoadmapLoadStatus.initial || RoadmapLoadStatus.loading =>
            const Center(child: CircularProgressIndicator()),
          RoadmapLoadStatus.failure => Center(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.spacing2xl),
              child: Text(
                state.message ?? 'Something went wrong',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          RoadmapLoadStatus.loaded => _TeacherRoadmapContent(
            roadmap: state.roadmap!,
          ),
        };
      },
    );
  }
}

class _TeacherRoadmapContent extends StatelessWidget {
  final GroupRoadmap roadmap;
  const _TeacherRoadmapContent({required this.roadmap});

  void _showAddModuleDialog(BuildContext context) {
    AppDialog.show(
      context: context,
      builder: (_) => AppDialog(
        title: 'Add Module',
        content: AnnouncementFormContent(
          firstFieldLabel: 'Title',
          firstFieldPlaceholder: 'Enter module title…',
          secondFieldLabel: 'Description',
          secondFieldPlaceholder: 'Enter module description…',
          submitLabel: 'Add Module',
          onSubmit: (title, description) {
            Navigator.of(context).pop();
            // TODO: dispatch add module cubit event
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.spacingLg.w,
        AppSpacing.spacingXl.h,
        AppSpacing.spacingLg.w,
        AppSpacing.spacing5xl.h,
      ),
      itemCount: 1 + roadmap.modules.length,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Padding(
            padding: EdgeInsets.only(bottom: AppSpacing.spacingXl.h),
            child: AppSectionHeader(
              title: 'Learning Path',
              onAdd: () => _showAddModuleDialog(context),
            ),
          );
        }

        final module = roadmap.modules[index - 1];
        return Padding(
          padding: EdgeInsets.only(
            bottom: index == roadmap.modules.length
                ? 0
                : AppSpacing.spacingXl.h,
            top: index == 0 ? 0 : AppSpacing.spacing2xl.h,
          ),
          child: _TeacherModuleCard(module: module),
        );
      },
    );
  }
}

//   Teacher Module card

class _TeacherModuleCard extends StatelessWidget {
  final GroupRoadmapModule module;
  const _TeacherModuleCard({required this.module});

  void _showInteractionOptions(BuildContext context) {
    AppDialog.show(
      context: context,
      builder: (_) => AppDialog(
        title: 'Interaction Options',
        content: _InteractionOptionsContent(moduleTitle: module.title),
      ),
    );
  }

  void _showEditModuleDialog(BuildContext context) {
    AppDialog.show(
      context: context,
      builder: (_) => AppDialog(
        title: 'Edit Module',
        content: AnnouncementFormContent(
          initialTitle: module.title,
          initialBody: module.description,
          firstFieldLabel: 'Title',
          firstFieldPlaceholder: 'Enter module title…',
          secondFieldLabel: 'Description',
          secondFieldPlaceholder: 'Enter module description…',
          submitLabel: 'Save Changes',
          onSubmit: (title, description) {
            Navigator.of(context).pop();
            // TODO: dispatch edit module cubit event
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ─ Circle icon — tapping opens Interaction Options ───────────────
        GestureDetector(
          onTap: () => _showInteractionOptions(context),
          child: Container(
            width: 48.w,
            height: 48.w,
            decoration: const BoxDecoration(
              color: AppColors.brandPrimary500,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.menu_book_rounded,
              color: AppColors.white,
              size: 24.sp,
            ),
          ),
        ),
        SizedBox(width: AppSpacing.spacingMd.w),
        // ─ Card ──────────────────────────────────────────────────
        Expanded(
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: cs.surface,
              borderRadius: BorderRadius.circular(AppRadius.radiusLg.r),
              boxShadow: AppShadows.elevation(theme.brightness),
            ),
            child: Padding(
              padding: EdgeInsets.all(AppSpacing.spacingLg.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top row: MODULE label + ⋮ overflow menu
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          module.moduleLabel,
                          style: AppTypography.labelSmall(
                            color: AppColors.brandPrimary500,
                          ),
                        ),
                      ),
                      AppOverflowMenu(
                        iconSize: 16,
                        items: [
                          AppOverflowMenuItem(
                            label: 'Edit',
                            icon: Icons.mode,
                            backgroundColor: AppColors.brandPrimary500,
                            onTap: () => _showEditModuleDialog(context),
                          ),
                          AppOverflowMenuItem(
                            label: 'Delete',
                            icon: Icons.delete,
                            backgroundColor: AppColors.brandSecondary500,
                            onTap: () {
                              // TODO: dispatch delete module cubit event
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: AppSpacing.spacingXs.h), // 4px
                  // Title
                  Text(
                    module.title,
                    style: AppTypography.h6(
                      color: cs.onSurface,
                    ).copyWith(fontWeight: AppTypography.extraBold),
                  ),

                  // Body
                  Text(
                    module.description,
                    style: AppTypography.bodySmall(color: cs.onSurfaceVariant),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ── Interaction Options dialog content ────────────────────────────────────────

class _InteractionOptionsContent extends StatelessWidget {
  final String moduleTitle;
  const _InteractionOptionsContent({required this.moduleTitle});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Subtitle — module name
        Text(
          moduleTitle,
          style: AppTypography.bodySmall(color: cs.onSurfaceVariant),
        ),
        SizedBox(height: AppSpacing.spacingLg.h), // 16px
        // Action buttons
        Row(
          children: [
            Expanded(
              child: _InteractionOptionButton(
                icon: Icons.assignment_rounded,
                label: 'Homework',
                filled: true,
                onTap: () {
                  Navigator.of(context).pop();
                  //   navigate to Homework
                },
              ),
            ),
            SizedBox(width: AppSpacing.spacingMd.w), // 12px
            Expanded(
              child: _InteractionOptionButton(
                icon: Icons.folder_rounded,
                label: 'Resources',
                filled: false,
                onTap: () {
                  Navigator.of(context).pop();
                  //  navigate to Resources
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _InteractionOptionButton extends StatelessWidget {
  final IconData icon;
  final String label;

  /// true  = solid brandPrimary500 bg, white content
  /// false = brandPrimary500Alpha10 bg + brandPrimary500 border, primary content
  final bool filled;
  final VoidCallback onTap;

  const _InteractionOptionButton({
    required this.icon,
    required this.label,
    required this.filled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final contentColor = filled ? AppColors.white : AppColors.brandPrimary500;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(AppSpacing.spacingLg.w), // 16px
        decoration: BoxDecoration(
          color: filled
              ? AppColors.brandPrimary500
              : AppColors.brandPrimary500Alpha10,
          border: filled ? null : Border.all(color: AppColors.brandPrimary500),
          borderRadius: BorderRadius.circular(AppRadius.radiusMd.r), // 16px
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 20.sp, color: contentColor),
            SizedBox(height: AppSpacing.spacingSm.h), // 8px
            Text(
              label,
              style: AppTypography.h6(
                color: contentColor,
              ).copyWith(fontWeight: AppTypography.extraBold),
            ),
          ],
        ),
      ),
    );
  }
}
