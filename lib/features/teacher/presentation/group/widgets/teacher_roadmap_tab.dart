import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_radius.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/config/routes.dart';
import 'package:elara/core/navigation/app_navigation.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:elara/features/student/domain/group/entities/group_roadmap.dart';
import 'package:elara/features/teacher/presentation/group/cubits/teacher_roadmap_cubit.dart';
import 'package:elara/features/teacher/domain/group/entities/teacher_roadmap_entity.dart';
import 'package:elara/features/teacher/presentation/homework/route_args/teacher_module_route_args.dart';
import 'package:elara/shared/widgets/announcement_form_content.dart';
import 'package:elara/shared/widgets/app_dialog.dart';
import 'package:elara/shared/widgets/app_overflow_menu.dart';
import 'package:elara/shared/widgets/app_section_header.dart';
import 'package:elara/shared/widgets/module_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:elara/core/localization/localization_extension.dart';

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
    return BlocBuilder<TeacherRoadmapCubit, TeacherRoadmapState>(
      builder: (context, state) {
        return switch (state.status) {
          TeacherRoadmapLoadStatus.initial ||
          TeacherRoadmapLoadStatus.loading => const Center(
            child: CircularProgressIndicator(),
          ),
          TeacherRoadmapLoadStatus.failure => Center(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.spacing2xl),
              child: Text(
                state.message ?? context.l10n.commonSomethingWentWrong,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          TeacherRoadmapLoadStatus.loaded => TeacherRoadmapContent(
            roadmap: state.roadmap!,
            groupId: groupId,
            subject: subject,
          ),
        };
      },
    );
  }
}

/// Shared roadmap module list used by the group tab and roadmap detail screen.
class TeacherRoadmapContent extends StatelessWidget {
  final TeacherRoadmapEntity roadmap;
  final String groupId;
  final String subject;

  const TeacherRoadmapContent({
    super.key,
    required this.roadmap,
    required this.groupId,
    required this.subject,
  });

  void _showAddModuleDialog(BuildContext context) {
    AppDialog.show(
      context: context,
      builder: (_) => AppDialog(
        title: context.l10n.teacherAddModule,
        content: AnnouncementFormContent(
          firstFieldLabel: context.l10n.teacherModuleTitle,
          firstFieldPlaceholder: context.l10n.teacherEnterModuleTitle,
          secondFieldLabel: context.l10n.teacherModuleDescription,
          secondFieldPlaceholder: context.l10n.teacherEnterModuleDescription,
          submitLabel: context.l10n.teacherAddModule,
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
              title: context.l10n.teacherLearningPath,
              onAdd: () => _showAddModuleDialog(context),
            ),
          );
        }

        final moduleIndex = index;
        final moduleEntity = roadmap.modules[index - 1];
        final moduleShim = GroupRoadmapModule(
          moduleLabel: context.l10n.teacherModuleLabel(moduleIndex),
          title: moduleEntity.title,
          description: moduleEntity.description,
          status: RoadmapModuleStatus.completed,
        );

        return Padding(
          padding: EdgeInsets.only(
            bottom: index == roadmap.modules.length
                ? 0
                : AppSpacing.spacingXl.h,
            top: index == 0 ? 0 : AppSpacing.spacing2xl.h,
          ),
          child: _TeacherModuleCard(
            moduleId: moduleEntity.id,
            module: moduleShim,
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
  final String moduleId;
  final GroupRoadmapModule module;
  final String groupId;
  final String subject;

  const _TeacherModuleCard({
    required this.moduleId,
    required this.module,
    required this.groupId,
    required this.subject,
  });

  void _showInteractionOptions(BuildContext context) {
    AppDialog.show(
      context: context,
      builder: (_) => AppDialog(
        title: context.l10n.teacherInteractionOptions,
        content: _InteractionOptionsContent(
          moduleId: moduleId,
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
        title: context.l10n.teacherEditModule,
        content: AnnouncementFormContent(
          initialTitle: module.title,
          initialBody: module.description,
          firstFieldLabel: context.l10n.teacherModuleTitle,
          firstFieldPlaceholder: context.l10n.teacherEnterModuleTitle,
          secondFieldLabel: context.l10n.teacherModuleDescription,
          secondFieldPlaceholder: context.l10n.teacherEnterModuleDescription,
          submitLabel: context.l10n.teacherSaveChanges,
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
            label: context.l10n.commonEdit,
            icon: Icons.mode,
            backgroundColor: AppColors.brandPrimary500,
            onTap: () => _showEditModuleDialog(context),
          ),
          AppOverflowMenuItem(
            label: context.l10n.commonDelete,
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
                label: context.l10n.teacherHomeworkLabel,
                filled: true,
                onTap: () {
                  Navigator.of(context).pop();
                  AppNavigation.pushNamed(
                    context,
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
                label: context.l10n.teacherResourcesLabel,
                filled: false,
                onTap: () {
                  Navigator.of(context).pop();
                  AppNavigation.pushNamed(
                    context,
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
