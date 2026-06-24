import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_radius.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/config/routes.dart';
import 'package:elara/core/navigation/app_navigation.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:elara/features/student/domain/group/entities/group_roadmap.dart';
import 'package:elara/features/student/presentation/group/cubits/roadmap_cubit.dart';
import 'package:elara/features/teacher/homework/presentation/route_args/teacher_module_route_args.dart';
import 'package:elara/shared/widgets/announcement_form_content.dart';
import 'package:elara/shared/widgets/app_dialog.dart';
import 'package:elara/shared/widgets/app_overflow_menu.dart';
import 'package:elara/shared/widgets/app_section_header.dart';
import 'package:elara/shared/widgets/module_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TeacherRoadmapTab extends StatelessWidget {
  final String groupId;
  final String subject;

  const TeacherRoadmapTab({
    super.key,
    required this.groupId,
    required this.subject,
  });

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
            groupId: groupId,
            subject: subject,
          ),
        };
      },
    );
  }
}

class _TeacherRoadmapContent extends StatelessWidget {
  final GroupRoadmap roadmap;
  final String groupId;
  final String subject;

  const _TeacherRoadmapContent({
    required this.roadmap,
    required this.groupId,
    required this.subject,
  });

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
          child: _TeacherModuleCard(
            module: module,
            groupId: groupId,
            subject: subject,
          ),
        );
      },
    );
  }
}

//   Teacher Module card

class _TeacherModuleCard extends StatelessWidget {
  final GroupRoadmapModule module;
  final String groupId;
  final String subject;

  const _TeacherModuleCard({
    required this.module,
    required this.groupId,
    required this.subject,
  });

  void _showInteractionOptions(BuildContext context) {
    AppDialog.show(
      context: context,
      builder: (_) => AppDialog(
        title: 'Interaction Options',
        content: _InteractionOptionsContent(
          moduleId: module.moduleLabel,
          moduleTitle: module.title,
          moduleLabel: module.moduleLabel,
          groupId: groupId,
          subject: subject,
        ),
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
    return ModuleCard(
      module: module,
      // Teacher leading: always brandPrimary500 circle, tapping opens dialog
      leading: GestureDetector(
        onTap: () => _showInteractionOptions(context),
        child: const ModuleLeadingCircle(
          icon: Icons.menu_book_rounded,
          iconColor: AppColors.white,
          fillColor: AppColors.brandPrimary500,
        ),
      ),
      // Teacher trailing: ⋮ overflow menu (Edit / Delete)
      cardTrailing: AppOverflowMenu(
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
    );
  }
}

// ── Interaction Options dialog content ────────────────────────────────────────

class _InteractionOptionsContent extends StatelessWidget {
  final String moduleId;
  final String moduleTitle;
  final String moduleLabel;
  final String groupId;
  final String subject;

  const _InteractionOptionsContent({
    required this.moduleId,
    required this.moduleTitle,
    required this.moduleLabel,
    required this.groupId,
    required this.subject,
  });

  TeacherModuleRouteArgs get _routeArgs => TeacherModuleRouteArgs(
    moduleId: moduleId,
    moduleTitle: moduleTitle,
    moduleLabel: moduleLabel,
    groupId: groupId,
    subject: subject,
  );

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
                  AppNavigation.pushNamed(context, 
                    AppRoutes.teacherModuleHomework,
                    arguments: _routeArgs,
                  );
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
                  AppNavigation.pushNamed(context, 
                    AppRoutes.teacherModuleResources,
                    arguments: _routeArgs,
                  );
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
