import 'package:elara/features/student/domain/group/entities/group_roadmap.dart';
import 'package:elara/features/student/presentation/group/widgets/roadmap/module/roadmap_module_status_ui.dart';
import 'package:elara/features/student/presentation/group/widgets/roadmap/module/roadmap_status_label.dart';
import 'package:elara/features/student/presentation/group/widgets/roadmap/sheet/module_sheet.dart';
import 'package:elara/shared/widgets/module_card.dart';
import 'package:flutter/material.dart';

/// One roadmap row: leading state icon + module card (student view).
///
/// Leading circle appearance and card trailing widget are driven by the
/// module's [RoadmapModuleStatus] via the [RoadmapModuleStatusUi] extension.
/// The card trailing slot renders a [RoadmapStatusLabel] (status chip).
class RoadmapModuleTile extends StatelessWidget {
  final GroupRoadmapModule module;

  const RoadmapModuleTile({super.key, required this.module});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final s = module.status;
    final border = s.moduleCardBorder(cs);

    // Build the leading circle; wrap in a GestureDetector when in-progress.
    final circle = ModuleLeadingCircle(
      icon: s.leadingIcon,
      iconColor: s.leadingIconColor,
      fillColor: s.leadingCircleFill,
      border: s.leadingCircleBorder,
    );

    final leading = s.isInProgress
        ? Semantics(
            button: true,
            label: 'Open interaction options for ${module.title}',
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => showModuleSheet(context, moduleTitle: module.title),
              child: circle,
            ),
          )
        : circle;

    return ModuleCard(
      module: module,
      leading: leading,
      cardTrailing: RoadmapStatusLabel(module: module),
      cardColor: s.moduleCardSurface(cs),
      cardBorder: Border.all(color: border.color, width: border.width),
      showShadow: s.moduleCardShowsShadow,
    );
  }
}
