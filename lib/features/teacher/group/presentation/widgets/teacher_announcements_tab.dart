import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:elara/features/student/domain/group/entities/group_announcement.dart';
import 'package:elara/features/student/presentation/group/cubits/announcements_cubit.dart';
import 'package:elara/features/teacher/group/presentation/cubits/teacher_announcements_cubit.dart';
import 'package:elara/shared/widgets/announcement_card.dart';
import 'package:elara/shared/widgets/announcement_form_content.dart';
import 'package:elara/shared/widgets/app_dialog.dart';
import 'package:elara/shared/widgets/app_section_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Teacher version of the Announcements tab.
/// Shows "Announcements" header + "+ Add" button.
/// Each card has a ⋮ overflow menu (Edit / Delete).
class TeacherAnnouncementsTab extends StatelessWidget {
  const TeacherAnnouncementsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TeacherAnnouncementsCubit, AnnouncementsState>(
      builder: (context, state) {
        return switch (state.status) {
          AnnouncementsLoadStatus.initial || AnnouncementsLoadStatus.loading =>
            const Center(child: CircularProgressIndicator()),
          AnnouncementsLoadStatus.failure => Center(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.spacing2xl),
              child: Text(
                state.message ?? 'Something went wrong',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          AnnouncementsLoadStatus.loaded => _TeacherAnnouncementsContent(
            items: state.items,
          ),
        };
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
        title: 'Add Announcement',
        content: AnnouncementFormContent(
          submitLabel: 'Add Announcement',
          onSubmit: (title, body) {
            Navigator.of(context).pop();
            // TODO: dispatch add announcement cubit event
          },
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context, GroupAnnouncement item) {
    AppDialog.show(
      context: context,
      builder: (_) => AppDialog(
        title: 'Edit Announcement',
        content: AnnouncementFormContent(
          initialTitle: item.title,
          initialBody: item.body,
          submitLabel: 'Save Changes',
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
          title: 'Announcements',
          onAdd: () => _showAddDialog(context),
        ),
        SizedBox(height: AppSpacing.spacingXl.h),

        if (items.isEmpty)
          Padding(
            padding: EdgeInsets.only(top: AppSpacing.spacing3xl.h),
            child: Text(
              'No announcements yet.',
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
                // TODO: dispatch delete announcement cubit event
              },
            ),
          ),
      ],
    );
  }
}
