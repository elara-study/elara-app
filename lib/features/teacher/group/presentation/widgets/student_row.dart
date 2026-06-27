import 'package:elara/core/theme/app_radius.dart';
import 'package:elara/core/theme/app_shadows.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:elara/features/teacher/group/domain/entities/teacher_student_entity.dart';
import 'package:elara/shared/widgets/progress_bar.dart';
import 'package:flutter/material.dart';

/// A single student row showing rank, avatar, name, XP, lesson progress + bar.
class StudentRow extends StatelessWidget {
  final TeacherStudentEntity student;

  const StudentRow({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(AppRadius.radiusLg),
        boxShadow: AppShadows.elevation(theme.brightness),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.spacingMd),
        child: Column(
          children: [
            Row(
              children: [
                // Rank
                Text(
                  '${student.rank}',
                  style: AppTypography.labelMedium(color: cs.onSurfaceVariant),
                ),
                const SizedBox(width: AppSpacing.spacingSm),
                // Avatar
                _Avatar(name: student.name),
                const SizedBox(width: AppSpacing.spacingSm),
                // Name
                Expanded(
                  child: Text(
                    student.name,
                    style: AppTypography.bodyMedium(color: cs.onSurface),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                // XP
                _XpBadge(xp: student.xp),
                const SizedBox(width: AppSpacing.spacingSm),
                // Streak
                _StreakBadge(streak: student.streak),
              ],
            ),
            const SizedBox(height: AppSpacing.spacingLg),
            // Progress bar
            ProgressBar(
              completedLabel: student.lessonProgressLabel,
              percentLabel: '${(student.progress * 100).round()}%',
              progress: student.progress,
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

class _XpBadge extends StatelessWidget {
  final int xp;

  const _XpBadge({required this.xp});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.bolt, size: 20, color: cs.onSurface),
        const SizedBox(width: 2),
        Text(
          xp.toString(),
          style: AppTypography.labelLarge(color: cs.onSurface),
        ),
      ],
    );
  }
}

class _StreakBadge extends StatelessWidget {
  final int streak;

  const _StreakBadge({required this.streak});

  @override
  Widget build(BuildContext context) {
    if (streak == 0) return const SizedBox.shrink();
    
    final cs = Theme.of(context).colorScheme;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.local_fire_department_rounded, size: 20, color: Colors.orange),
        const SizedBox(width: 2),
        Text(
          streak.toString(),
          style: AppTypography.labelLarge(color: cs.onSurface),
        ),
      ],
    );
  }
}
