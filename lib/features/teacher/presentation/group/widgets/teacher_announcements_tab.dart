import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:elara/features/student/domain/group/entities/group_announcement.dart';
import 'package:elara/features/teacher/presentation/group/cubits/teacher_announcements_cubit.dart';
import 'package:elara/shared/widgets/announcement_card.dart';
import 'package:elara/shared/widgets/announcement_form_content.dart';
import 'package:elara/shared/widgets/app_dialog.dart';
import 'package:elara/shared/widgets/app_section_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:elara/core/localization/localization_extension.dart';

/// Teacher version of the Announcements tab.
/// Shows "Announcements" header + "+ Add" button.
/// Each card has a ⋮ overflow menu (Edit / Delete).
class TeacherAnnouncementsTab extends StatelessWidget {
  const TeacherAnnouncementsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TeacherAnnouncementsCubit, TeacherAnnouncementsState>(
      builder: (context, state) {
        if (state is TeacherAnnouncementsInitial ||
            state is TeacherAnnouncementsLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is TeacherAnnouncementsError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.spacing2xl),
              child: Text(
                state.message,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ),
          );
        } else if (state is TeacherAnnouncementsLoaded) {
          return _TeacherAnnouncementsContent(items: state.announcements);
        }
        return const SizedBox.shrink();
      },
    );
  }
}

// ── Content ───────────────────────────────────────────────────────────────────

class _TeacherAnnouncementsContent extends StatelessWidget {
  final List<GroupAnnouncement> items;
  const _TeacherAnnouncementsContent({required this.items});

  void _showAddDialog(BuildContext context) {
    AppDialog.show(
      context: context,
      builder: (_) => AppDialog(
        title: context.l10n.teacherAddAnnouncement,
        content: AnnouncementFormContent(
          submitLabel: context.l10n.teacherAddAnnouncement,
          onSubmit: (title, body) {
            Navigator.of(context).pop();
            context.read<TeacherAnnouncementsCubit>().addAnnouncement(
              title,
              body,
            );
          },
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context, GroupAnnouncement item) {
    AppDialog.show(
      context: context,
      builder: (_) => AppDialog(
        title: context.l10n.teacherEditAnnouncement,
        content: AnnouncementFormContent(
          initialTitle: item.title,
          initialBody: item.content,
          submitLabel: context.l10n.teacherSaveChanges,
          onSubmit: (title, body) {
            Navigator.of(context).pop();
            // TODO: dispatch edit announcement cubit event
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return ListView(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.spacingLg.w,
        AppSpacing.spacingXl.h,
        AppSpacing.spacingLg.w,
        AppSpacing.spacing5xl.h,
      ),
      children: [
        AppSectionHeader(
          title: context.l10n.teacherAnnouncements,
          onAdd: () => _showAddDialog(context),
        ),
        SizedBox(height: AppSpacing.spacingXl.h),

        if (items.isEmpty)
          Padding(
            padding: EdgeInsets.only(top: AppSpacing.spacing3xl.h),
            child: Text(
              context.l10n.teacherNoAnnouncementsYet,
              style: AppTypography.bodyMedium(color: cs.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
          )
        else
          ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            itemCount: items.length,
            separatorBuilder: (_, __) =>
                SizedBox(height: AppSpacing.spacingMd.h),
            itemBuilder: (ctx, i) => AnnouncementCard(
              announcement: items[i],
              onEdit: () => _showEditDialog(ctx, items[i]),
              onDelete: () {
                context.read<TeacherAnnouncementsCubit>().deleteAnnouncement(
                  items[i].id,
                );
              },
            ),
          ),
      ],
    );
  }
}
