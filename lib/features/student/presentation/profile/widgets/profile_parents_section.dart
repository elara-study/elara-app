import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:elara/features/student/domain/profile/entities/profile_linked_parent_entity.dart';
import 'package:elara/features/student/presentation/profile/widgets/profile_link_parent_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileParentsSection extends StatelessWidget {
  const ProfileParentsSection({super.key, required this.parents});

  final List<ProfileLinkedParentEntity> parents;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Parents',
                style: AppTypography.h4(color: cs.onSurface),
              ),
            ),
            FilledButton(
              onPressed: () => showProfileLinkParentSheet(context),
              style: FilledButton.styleFrom(
                visualDensity: VisualDensity.compact,
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.spacingSm.w,
                  vertical: AppSpacing.spacingXs.h,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Add',
                    style: AppTypography.labelSmall(color: cs.onPrimary),
                  ),
                  SizedBox(width: AppSpacing.spacingXs.w),
                  Icon(Icons.add_rounded, size: 16.sp, color: cs.onPrimary),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: AppSpacing.spacingLg.h),
        Row(
          children: [
            for (var i = 0; i < parents.length; i++) ...[
              if (i > 0) SizedBox(width: AppSpacing.spacingLg.w),
              _ProfileParentChip(name: parents[i].displayName),
            ],
          ],
        ),
      ],
    );
  }
}

class _ProfileParentChip extends StatelessWidget {
  const _ProfileParentChip({required this.name});

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
