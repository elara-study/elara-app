import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_radius.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:elara/features/student/profile/domain/entities/profile_achievement_preview_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileRecentAchievementsSection extends StatelessWidget {
  const ProfileRecentAchievementsSection({
    super.key,
    required this.achievements,
  });

  final List<ProfileAchievementPreviewEntity> achievements;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Achievements',
          style: AppTypography.h4(color: cs.onSurface),
        ),
        SizedBox(height: AppSpacing.spacingLg.h),
        Row(
          children: [
            for (var i = 0; i < achievements.length; i++) ...[
              if (i > 0) SizedBox(width: AppSpacing.spacingLg.w),
              _ProfileBadgeChip(
                label: achievements[i].label,
                icon: Icons.emoji_events_rounded,
              ),
            ],
          ],
        ),
      ],
    );
  }
}

class _ProfileBadgeChip extends StatelessWidget {
  const _ProfileBadgeChip({required this.label, required this.icon});

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.brandAccent500,
            borderRadius: BorderRadius.circular(AppRadius.radiusMd.r),
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withValues(alpha: 0.08),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(AppSpacing.spacingLg.r),
            child: Icon(icon, size: 24.sp, color: AppColors.white),
          ),
        ),
        SizedBox(height: AppSpacing.spacingXs.h),
        Text(label, style: AppTypography.labelSmall(color: cs.onSurface)),
      ],
    );
  }
}
