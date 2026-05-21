import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/features/student/domain/group/entities/group_roadmap.dart';
import 'package:elara/features/student/presentation/group/widgets/roadmap/module/roadmap_module_tile.dart';
import 'package:elara/shared/widgets/app_section_header.dart';
import 'package:flutter/material.dart';

class RoadmapContent extends StatelessWidget {
  final GroupRoadmap roadmap;

  const RoadmapContent({super.key, required this.roadmap});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final percent = (roadmap.completedFraction * 100).round().clamp(0, 100);

    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.spacingLg),
      itemCount: 1 + roadmap.modules.length,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.spacingXl),
            child: AppSectionHeader(
              title: 'Learning Path',
              trailing: Text(
                '$percent% completed',
                style: textTheme.bodyMedium,
              ),
            ),
          );
        }
        final module = roadmap.modules[index - 1];
        return Padding(
          padding: EdgeInsets.only(
            bottom: index == roadmap.modules.length ? 0 : AppSpacing.spacingXl,
          ),
          child: RoadmapModuleTile(module: module),
        );
      },
    );
  }
}
