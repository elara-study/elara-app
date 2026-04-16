import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_radius.dart';
import 'package:elara/core/theme/app_shadows.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:elara/features/student/group/domain/entities/group_leaderboard_entry.dart';
import 'package:elara/features/student/group/presentation/widgets/progress_bar.dart';
import 'package:flutter/material.dart';

class LeaderboardRow extends StatelessWidget {
  final GroupLeaderboardEntry entry;

  const LeaderboardRow({super.key, required this.entry});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final bg = entry.isCurrentUser
        ? AppColors.brandPrimary500Alpha20
        : cs.surface;
    final border = entry.isCurrentUser
        ? AppColors.brandPrimary500
        : Colors.transparent;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppRadius.radiusLg),
        border: Border.all(color: border),
        boxShadow: AppShadows.elevation(theme.brightness),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.spacingMd),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  '${entry.rank}',
                  style: AppTypography.labelMedium(color: cs.onSurfaceVariant),
                ),
                const SizedBox(width: AppSpacing.spacingSm),
                _Avatar(name: entry.memberName),
                const SizedBox(width: AppSpacing.spacingSm),

                Text(
                  entry.memberName,
                  style: AppTypography.bodyMedium(color: cs.onSurface),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const Spacer(),
                _Points(
                  points: entry.points,
                  isCurrentUser: entry.isCurrentUser,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.spacingLg),
            ProgressBar(
              completedLabel:
                  'Lesson ${entry.completedLessons} of ${entry.totalLessons}',
              percentLabel: '${(entry.progress * 100).round()}%',
              progress: entry.progress,
              metaLabelColor: cs.onSurface,
            ),
          ],
        ),
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  final String name;

  const _Avatar({required this.name});

  String get _initials {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first.characters.take(1).toString();
    return (parts[0].characters.take(1).toString() +
            parts[1].characters.take(1).toString())
        .toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return CircleAvatar(
      backgroundColor: cs.surfaceContainerHighest,
      foregroundColor: cs.onSurface,
      child: Text(_initials, style: AppTypography.labelMedium()),
    );
  }
}

class _Points extends StatelessWidget {
  final int points;
  final bool isCurrentUser;

  const _Points({required this.points, required this.isCurrentUser});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final boltColor = isCurrentUser ? cs.primary : cs.onSurface;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.bolt, size: 24, color: boltColor),
        const SizedBox(width: 3),
        Text(
          points.toString(),
          style: AppTypography.labelLarge(color: cs.onSurface),
        ),
      ],
    );
  }
}
