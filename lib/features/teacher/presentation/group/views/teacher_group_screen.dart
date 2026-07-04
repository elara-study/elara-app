import 'package:elara/core/theme/app_icon_sizes.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/core/utils/app_snackbar.dart';
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

class TeacherGroupScreen extends StatelessWidget {
  final TeacherGroupEntity group;

  const TeacherGroupScreen({super.key, required this.group});

  static const _tabs = [
    Tab(text: 'Students'),
    Tab(text: 'Roadmap'),
    Tab(text: 'Announcements'),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocListener<TeacherGroupCubit, TeacherGroupState>(
      listener: (context, state) {
        if (state is TeacherGroupDeleted) {
          Navigator.of(context).pop();
        } else if (state is TeacherGroupError) {
          AppSnackBar.error(context, state.message);
        }
      },
      child: DefaultTabController(
        length: _tabs.length,
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
                        'Delete Group',
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
                tabs: _tabs,
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
        title: const Text('Delete Group'),
        content: const Text(
          'Are you sure you want to delete this group? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              context.read<TeacherGroupCubit>().deleteGroup(group.id);
            },
            child: Text(
              'Delete',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ],
      ),
    );
  }
}
