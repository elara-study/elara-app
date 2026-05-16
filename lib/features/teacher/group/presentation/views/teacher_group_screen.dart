import 'package:elara/core/theme/app_icon_sizes.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/shared/widgets/app_tab_bar.dart';
import 'package:elara/features/teacher/domain/entities/teacher_group_entity.dart';
import 'package:elara/features/teacher/group/presentation/widgets/students_tab.dart';
import 'package:elara/features/teacher/group/presentation/widgets/teacher_announcements_tab.dart';
import 'package:elara/features/teacher/group/presentation/widgets/teacher_roadmap_tab.dart';
import 'package:elara/shared/widgets/app_glass_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class TeacherGroupScreen extends StatelessWidget {
  final TeacherGroupEntity group;

  const TeacherGroupScreen({super.key, required this.group});

  static const _tabs = ['Students', 'Roadmap', 'Announcements'];

  @override
  Widget build(BuildContext context) {
    //final theme = Theme.of(context);

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
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.spacingLg.w,
                vertical: AppSpacing.spacing2xl.h,
              ),
              child: Builder(
                builder: (context) {
                  final controller = DefaultTabController.of(context);
                  return AnimatedBuilder(
                    animation: controller,
                    builder: (context, _) {
                      return AppTabBar(
                        tabs: _tabs,
                        activeTab: controller.index,
                        onTabChanged: (idx) => controller.animateTo(idx),
                      );
                    },
                  );
                },
              ),
            ),
            const Expanded(
              child: TabBarView(
                children: [
                  StudentsTab(),
                  TeacherRoadmapTab(),
                  TeacherAnnouncementsTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
