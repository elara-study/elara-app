import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_radius.dart';
import 'package:elara/core/theme/app_shadows.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';

/// Chat session row — same shell as [AnnouncementCard] / [QuizQuestionCard]:
/// left orange accent, lifted surface, title + time, preview body.
class HistorySessionCard extends StatelessWidget {
  const HistorySessionCard({
    super.key,
    required this.title,
    required this.timeLabel,
    required this.preview,
    required this.onTap,
    this.onDelete,
  });

  final String title;
  final String timeLabel;
  final String preview;
  final VoidCallback onTap;
  final VoidCallback? onDelete;

  static const double _accentWidth = 3;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final onMuted = cs.onSurfaceVariant;

    final titleStyle = theme.textTheme.headlineSmall?.copyWith(
      fontWeight: FontWeight.w900,
    );
    final metaStyle = theme.textTheme.labelSmall?.copyWith(
      fontSize: 10,
      height: 1.2,
      color: onMuted,
    );
    final bodyStyle = theme.textTheme.bodySmall?.copyWith(
      fontSize: 10,
      height: 1.45,
      color: onMuted,
    );

    return Semantics(
      container: true,
      label: title,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppRadius.radiusLg),
          onTap: onTap,
          child: Ink(
            decoration: BoxDecoration(
              color: cs.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(AppRadius.radiusLg),
              border: const Border(
                left: BorderSide(
                  width: _accentWidth,
                  color: AppColors.brandSecondary500,
                ),
              ),
              boxShadow: AppShadows.elevation(theme.brightness),
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.spacingLg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: Text(title, style: titleStyle)),
                      if (timeLabel.isNotEmpty) ...[
                        const SizedBox(width: AppSpacing.spacingSm),
                        Text(timeLabel, style: metaStyle),
                      ],
                      if (onDelete != null)
                        IconButton(
                          visualDensity: VisualDensity.compact,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(
                            minWidth: 32,
                            minHeight: 32,
                          ),
                          icon: Icon(
                            Icons.more_horiz_rounded,
                            color: onMuted,
                            size: 20,
                          ),
                          onPressed: onDelete,
                        ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.spacingSm),
                  Text(preview, style: bodyStyle),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
