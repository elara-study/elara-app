import 'package:elara/core/theme/app_radius.dart';
import 'package:elara/core/theme/app_shadows.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/features/student/group/domain/entities/group_roadmap.dart';
import 'package:elara/features/student/group/presentation/widgets/roadmap/module/roadmap_module_status_ui.dart';
import 'package:elara/features/student/group/presentation/widgets/roadmap/module/roadmap_status_label.dart';
import 'package:elara/features/student/group/presentation/widgets/roadmap/sheet/module_sheet.dart';
import 'package:flutter/material.dart';

/// One roadmap row: leading state icon + module card.
class RoadmapModuleTile extends StatelessWidget {
  final GroupRoadmapModule module;

  const RoadmapModuleTile({super.key, required this.module});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _LeadingIcon(module: module),
        const SizedBox(width: AppSpacing.spacingMd),
        Expanded(child: _ModuleCard(module: module)),
      ],
    );
  }
}

class _LeadingIcon extends StatelessWidget {
  final GroupRoadmapModule module;

  const _LeadingIcon({required this.module});

  @override
  Widget build(BuildContext context) {
    final shadows = AppShadows.elevation(Theme.of(context).brightness);
    const size = 48.0;
    final s = module.status;
    final iconSize = IconTheme.of(context).size ?? 24;

    final circle = DecoratedBox(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: s.leadingCircleFill,
        border: s.leadingCircleBorder,
        boxShadow: shadows,
      ),
      child: SizedBox(
        width: size,
        height: size,
        child: Center(
          child: Icon(s.leadingIcon, color: s.leadingIconColor, size: iconSize),
        ),
      ),
    );

    if (!s.isInProgress) {
      return circle;
    }

    return Semantics(
      button: true,
      label: 'Open interaction options for ${module.title}',
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => showModuleSheet(context, moduleTitle: module.title),
        child: circle,
      ),
    );
  }
}

class _ModuleCard extends StatelessWidget {
  final GroupRoadmapModule module;

  const _ModuleCard({required this.module});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final shadows = AppShadows.elevation(theme.brightness);
    final textTheme = theme.textTheme;
    final cs = theme.colorScheme;
    final st = module.status;
    final border = st.moduleCardBorder(cs);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: st.moduleCardSurface(cs),
        borderRadius: BorderRadius.circular(AppRadius.radiusMd),
        border: Border.all(color: border.color, width: border.width),
        boxShadow: st.moduleCardShowsShadow ? shadows : null,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.spacingMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        module.moduleLabel,
                        style: textTheme.labelSmall?.copyWith(
                          color: st.moduleLabelColor(cs),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.spacing2xs),
                      Text(
                        module.title,
                        style: textTheme.headlineSmall?.copyWith(
                          color: st.moduleTitleColor(cs),
                        ),
                      ),
                    ],
                  ),
                ),
                RoadmapStatusLabel(module: module),
              ],
            ),
            const SizedBox(height: AppSpacing.spacingSm),
            Text(
              module.description,
              style: textTheme.bodySmall?.copyWith(color: cs.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}
