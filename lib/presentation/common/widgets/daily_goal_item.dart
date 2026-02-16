import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_radius.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:flutter/material.dart';

/// A single daily goal row (icon, label, progress bar, points). Use inside [DailyGoalsCard].
class DailyGoalItem extends StatelessWidget {
  const DailyGoalItem({
    super.key,
    required this.icon,
    required this.label,
    required this.progress,
    required this.points,
    required this.backgroundColor,
  });
  final Color backgroundColor;
  final IconData icon;
  final String label;
  final double progress;
  final int points;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.spacingLg,
        vertical: AppSpacing.spacingMd,
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: backgroundColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.brandPrimary600, size: 20),
          ),
          const SizedBox(width: AppSpacing.spacingMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: AppTypography.bodyMedium()),
                const SizedBox(height: AppSpacing.spacingXs),
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadius.radiusFull),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: AppColors.brandPrimary100,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      AppColors.brandPrimary700,
                    ),
                    minHeight: 8,
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '+$points',
                style: AppTypography.labelMedium(
                  color: AppColors.brandSecondary600,
                ),
              ),
              const SizedBox(width: AppSpacing.spacing2xs),
              Icon(Icons.bolt, size: 14, color: AppColors.brandAccent500),
            ],
          ),
        ],
      ),
    );
  }
}

/// Card containing multiple [DailyGoalItem]s.
class DailyGoalsCard extends StatelessWidget {
  const DailyGoalsCard({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.radiusMd),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < children.length; i++) ...[
            children[i],
            if (i < children.length - 1)
              const SizedBox(height: AppSpacing.spacingSm),
          ],
        ],
      ),
    );
  }
}
