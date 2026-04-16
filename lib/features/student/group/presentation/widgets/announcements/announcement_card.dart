import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_radius.dart';
import 'package:elara/core/theme/app_shadows.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/features/student/group/domain/entities/group_announcement.dart';
import 'package:flutter/material.dart';

/// Single announcement row: left accent, title + time, body copy.
class AnnouncementCard extends StatelessWidget {
  final GroupAnnouncement announcement;

  const AnnouncementCard({super.key, required this.announcement});

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
      label: announcement.title,
      child: DecoratedBox(
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
                  Expanded(child: Text(announcement.title, style: titleStyle)),
                  const SizedBox(width: AppSpacing.spacingSm),
                  Text(announcement.relativeTimeLabel, style: metaStyle),
                ],
              ),
              const SizedBox(height: AppSpacing.spacingSm),
              Text(announcement.body, style: bodyStyle),
            ],
          ),
        ),
      ),
    );
  }
}
