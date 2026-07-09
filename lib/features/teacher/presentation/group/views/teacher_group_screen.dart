import 'package:elara/core/theme/app_icon_sizes.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/features/teacher/domain/group/entities/teacher_group_entity.dart';
import 'package:elara/features/teacher/presentation/group/widgets/students_tab.dart';
import 'package:elara/features/teacher/presentation/group/widgets/teacher_announcements_tab.dart';
import 'package:elara/features/teacher/presentation/group/widgets/teacher_roadmap_tab.dart';
import 'package:elara/shared/widgets/app_glass_header.dart';
import 'package:elara/shared/widgets/pill_tab_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:elara/features/teacher/presentation/group/cubits/teacher_group_cubit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:elara/core/localization/localization_extension.dart';

class TeacherGroupScreen extends StatelessWidget {
  final TeacherGroupEntity group;

  const TeacherGroupScreen({super.key, required this.group});



  @override
  Widget build(BuildContext context) {
    final tabs = [
      Tab(text: context.l10n.teacherStudents),
      Tab(text: context.l10n.teacherRoadmapsTitle),
      Tab(text: context.l10n.teacherAnnouncements),
    ];
    return BlocListener<TeacherGroupCubit, TeacherGroupState>(
      listener: (context, state) {
        if (state is TeacherGroupDeleted) {
          Navigator.of(context).pop();
        } else if (state is TeacherGroupError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: DefaultTabController(
        length: tabs.length,
        child: Scaffold(
          appBar: AppGlassHeader(
            title: group.name,
            subtitle: '${group.subject} • ${group.grade}',
            actions: [
              Padding(
                padding: EdgeInsets.only(right: AppSpacing.spacingLg.w),
                child: PopupMenuButton<String>(
                  icon: SvgPicture.asset(
                    'assets/icons/settings_icon.svg',
                    height: AppIconSizes.iconSm.h,
                    width: AppIconSizes.iconSm.w,
                    colorFilter: ColorFilter.mode(
                      Theme.of(context).colorScheme.onSurface,
                      BlendMode.srcIn,
                    ),
                  ),
                  onSelected: (value) {
                    if (value == 'delete') {
                      _showDeleteConfirmation(context);
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'delete',
                      child: Text(
                        context.l10n.teacherDeleteGroup,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              PillTabBar(
                tabs: tabs,
                padding: EdgeInsets.fromLTRB(
                  AppSpacing.spacingLg.w,
                  AppSpacing.spacingMd.h,
                  AppSpacing.spacingLg.w,
                  AppSpacing.spacingLg.h,
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    StudentsTab(group: group),
                    TeacherRoadmapTab(
                      groupId: group.id,
                      subject: group.subject,
                    ),
                    const TeacherAnnouncementsTab(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(context.l10n.teacherDeleteGroup),
        content: Text(context.l10n.teacherDeleteGroupConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(context.l10n.commonCancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              context.read<TeacherGroupCubit>().deleteGroup(group.id);
            },
            child: Text(
              context.l10n.commonDelete,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ],
      ),
    );
  }
}
