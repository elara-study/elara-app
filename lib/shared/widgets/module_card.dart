import 'package:elara/core/theme/app_radius.dart';
import 'package:elara/core/theme/app_shadows.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/features/student/domain/group/entities/group_roadmap.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

//   ModuleCard

/// Shared roadmap module row card.
///
/// Layout: [leading circle] [card (label · title · description · trailing)]
///
/// Used by:
///  - **Student roadmap** — status-driven leading icon, status chip trailing
///  - **Teacher roadmap** — always-filled brandPrimary500 circle, ⋮ menu trailing
///
/// The variable parts are injected via widget slots so each caller keeps its
/// own specific logic:
///  - [leading]      — the 48×48 circle widget (built by the caller)
///  - [cardTrailing] — optional widget on the top-right of the card
///                     (e.g. [RoadmapStatusLabel] or [AppOverflowMenu])
///  - [cardColor]    — card background; defaults to [cs.surface]
///  - [cardBorder]   — optional border around the card
///  - [showShadow]   — whether to draw the elevation shadow; defaults to true
class ModuleCard extends StatelessWidget {
  final GroupRoadmapModule module;

  /// 48×48 circle shown to the left of the card.
  final Widget leading;

  /// Optional widget anchored to the top-right corner of the card header.
  final Widget? cardTrailing;

  /// Card background colour. Defaults to [ColorScheme.surface].
  final Color? cardColor;

  /// Optional border around the card.
  final BoxBorder? cardBorder;

  /// Whether to paint the elevation shadow. Defaults to `true`.
  final bool showShadow;

  const ModuleCard({
    super.key,
    required this.module,
    required this.leading,
    this.cardTrailing,
    this.cardColor,
    this.cardBorder,
    this.showShadow = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Leading circle ───────────────────────────────────────────
        leading,
        SizedBox(width: AppSpacing.spacingMd.w),

        // ── Card ─────────────────────────────────────────────────────
        Expanded(
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: cardColor ?? cs.surface,
              borderRadius: BorderRadius.circular(AppRadius.radiusLg.r),
              border: cardBorder,
              boxShadow: showShadow
                  ? AppShadows.elevation(theme.brightness)
                  : null,
            ),
            child: Padding(
              padding: EdgeInsets.all(AppSpacing.spacingLg.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top row: module label (left) + optional trailing (right)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          module.moduleLabel,
                          style: textTheme.labelSmall,
                        ),
                      ),
                      if (cardTrailing != null) cardTrailing!,
                    ],
                  ),
                  SizedBox(height: AppSpacing.spacingXs.h),

                  // Module title
                  Text(module.title, style: textTheme.headlineSmall),

                  SizedBox(height: AppSpacing.spacingXs.h),

                  // Description
                  Text(
                    module.description,
                    style: textTheme.bodySmall?.copyWith(
                      color: cs.onSurfaceVariant,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ── ModuleLeadingCircle ────────────────────────────────────────────────────────

/// A 48×48 circle used as the leading icon in [ModuleCard].
///
/// Wrap in a [GestureDetector] at the call site when tap behaviour is needed.
class ModuleLeadingCircle extends StatelessWidget {
  /// Icon rendered inside the circle.
  final IconData icon;

  /// Icon colour.
  final Color iconColor;

  /// Circle fill colour.
  final Color fillColor;

  /// Optional border drawn around the circle.
  final BoxBorder? border;

  const ModuleLeadingCircle({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.fillColor,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    final iconSize = IconTheme.of(context).size ?? 24;
    final shadows = AppShadows.elevation(Theme.of(context).brightness);

    return DecoratedBox(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: fillColor,
        border: border,
        boxShadow: shadows,
      ),
      child: SizedBox(
        width: 48.w,
        height: 48.w,
        child: Center(
          child: Icon(icon, color: iconColor, size: iconSize.toDouble()),
        ),
      ),
    );
  }
}
