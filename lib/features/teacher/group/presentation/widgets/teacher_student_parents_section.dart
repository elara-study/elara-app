import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:elara/features/student/domain/profile/entities/profile_linked_parent_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Parents row on the group student profile (Figma Parents section).
class TeacherStudentParentsSection extends StatelessWidget {
  const TeacherStudentParentsSection({super.key, required this.parents});

  final List<ProfileLinkedParentEntity> parents;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Parents', style: AppTypography.h4(color: cs.onSurface)),
        SizedBox(height: AppSpacing.spacingLg.h),
        Row(
          children: [
            for (var i = 0; i < parents.length; i++) ...[
              if (i > 0) SizedBox(width: AppSpacing.spacingLg.w),
              _ParentChip(name: parents[i].displayName),
            ],
          ],
        ),
      ],
    );
  }
}

class _ParentChip extends StatelessWidget {
  const _ParentChip({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      children: [
        CircleAvatar(
          radius: 28.r,
          backgroundColor: cs.surfaceContainerHighest,
          child: Icon(
            Icons.person_rounded,
            color: cs.onSurfaceVariant,
            size: 28.sp,
          ),
        ),
        SizedBox(height: AppSpacing.spacingXs.h),
        Text(name, style: AppTypography.labelSmall(color: cs.onSurface)),
      ],
    );
  }
}
