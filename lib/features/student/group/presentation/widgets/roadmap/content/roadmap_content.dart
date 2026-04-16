import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/features/student/group/domain/entities/group_roadmap.dart';
import 'package:elara/features/student/group/presentation/widgets/roadmap/content/roadmap_learning_path_header.dart';
import 'package:elara/features/student/group/presentation/widgets/roadmap/module/roadmap_module_tile.dart';
import 'package:flutter/material.dart';

class RoadmapContent extends StatelessWidget {
  final GroupRoadmap roadmap;

  const RoadmapContent({super.key, required this.roadmap});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.spacingLg),
      itemCount: 1 + roadmap.modules.length,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.spacingXl),
            child: RoadmapLearningPathHeader(
              completedFraction: roadmap.completedFraction,
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
