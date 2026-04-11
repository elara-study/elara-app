import 'package:elara/core/theme/app_radius.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/features/student/group/domain/entities/group_roadmap.dart';
import 'package:elara/features/student/group/presentation/widgets/roadmap/module/roadmap_module_status_ui.dart';
import 'package:flutter/material.dart';

/// Default status chip label for a roadmap module.
String roadmapStatusDisplayLabel(GroupRoadmapModule module) {
  if (module.statusLabelOverride != null &&
      module.statusLabelOverride!.isNotEmpty) {
    return module.statusLabelOverride!;
  }
  return module.status.defaultDisplayLabel;
}

class RoadmapStatusLabel extends StatelessWidget {
  final GroupRoadmapModule module;

  const RoadmapStatusLabel({super.key, required this.module});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final textTheme = theme.textTheme;
    final label = roadmapStatusDisplayLabel(module);
    final colors = module.status.chipColors(cs);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: BorderRadius.circular(AppRadius.radiusFull),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.spacingSm,
          vertical: AppSpacing.spacing2xs,
        ),
        child: Text(
          label,
          style: textTheme.labelSmall?.copyWith(
            fontSize: 8,
            height: 1.25,
            fontWeight: FontWeight.w600,
            color: colors.foreground,
          ),
        ),
      ),
    );
  }
}
