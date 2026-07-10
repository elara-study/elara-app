import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_radius.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:elara/shared/widgets/progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:elara/core/localization/localization_extension.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileLevelProgressCard extends StatelessWidget {
  const ProfileLevelProgressCard({
    super.key,
    required this.formatThousands,
    required this.nextLevel,
    required this.xpCurrent,
    required this.xpGoal,
    required this.remainder,
  });

  final String Function(int) formatThousands;
  final int nextLevel;
  final int xpCurrent;
  final int xpGoal;
  final int remainder;

  @override
  Widget build(BuildContext context) {
    final progress = xpGoal == 0 ? 0.0 : (xpCurrent / xpGoal).clamp(0.0, 1.0);
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.brandPrimary500, AppColors.brandPrimary400],
        ),
        borderRadius: BorderRadius.circular(AppRadius.radiusXl.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.spacing2xl.r),
        child: Column(
          children: [
            ProgressBar(
              completedLabel: context.l10n.profileProgressToLevel(nextLevel),
              percentLabel:
                  '${formatThousands(xpCurrent)} / ${formatThousands(xpGoal)} XP',
              progress: progress,
              completedLabelColor: AppColors.neutral50,
              percentLabelColor: AppColors.neutral200,
              barHeight: 8.h,
              trackColor: AppColors.brandPrimary100.withValues(alpha: 0.5),
            ),
            SizedBox(height: AppSpacing.spacingXs.h),
            Text(
              context.l10n.profileXpToNextLevel(remainder),
              textAlign: TextAlign.center,
              style: AppTypography.labelSmall(
                color: AppColors.neutral200,
              ).copyWith(height: 18 / 12),
            ),
          ],
        ),
      ),
    );
  }
}
