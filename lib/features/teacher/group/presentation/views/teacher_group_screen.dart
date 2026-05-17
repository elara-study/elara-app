import 'package:elara/core/theme/app_icon_sizes.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/features/teacher/domain/entities/teacher_group_entity.dart';
import 'package:elara/features/teacher/group/presentation/widgets/students_tab.dart';
import 'package:elara/features/teacher/group/presentation/widgets/teacher_announcements_tab.dart';
import 'package:elara/features/teacher/group/presentation/widgets/teacher_roadmap_tab.dart';
import 'package:elara/shared/widgets/app_glass_header.dart';
import 'package:elara/shared/widgets/pill_tab_bar.dart';
import 'package:flutter/material.dart';
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
    return DefaultTabController(
      length: _tabs.length,
      child: Scaffold(
        appBar: AppGlassHeader(
          title: group.subject,
          subtitle: '${group.subject} • ${group.grade}',
          actions: [
            Padding(
              padding: EdgeInsets.only(right: AppSpacing.spacing2xl.w),
              child: SvgPicture.asset(
                'assets/icons/settings_icon.svg',
                height: AppIconSizes.iconSm.h,
                width: AppIconSizes.iconSm.w,
                colorFilter: ColorFilter.mode(
                  Theme.of(context).colorScheme.onSurface,
                  BlendMode.srcIn,
                ),
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
                  const TeacherRoadmapTab(),
                  const TeacherAnnouncementsTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
