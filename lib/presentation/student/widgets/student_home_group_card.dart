import 'package:elara/config/routes.dart';
import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_radius.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:elara/presentation/common/widgets/card_with_circle_background.dart';
import 'package:flutter/material.dart';

/// Data for a Student Home group card.
class StudentHomeGroup {
  const StudentHomeGroup({
    required this.name,
    required this.progress,
    required this.isPrimary,
  });

  final String name;
  final int progress;
  final bool isPrimary;
}

/// Group card for Student Home "My Groups" section.
class StudentHomeGroupCard extends StatelessWidget {
  const StudentHomeGroupCard({super.key, required this.group});

  final StudentHomeGroup group;

  @override
  Widget build(BuildContext context) {
    final bgColor = group.isPrimary
        ? AppGradients.custom(AppColors.brandPrimary400, AppColors.primary500)
        : AppGradients.custom(
            AppColors.brandSecondary400,
            AppColors.brandSecondary500,
          );
    return CardWithCircleBackground(
      circleLayout: CardCircleLayout.leftOnly,
      gradient: bgColor,
      child: InkWell(
        onTap: () =>
            Navigator.of(context).pushNamed(AppRoutes.studentClassDetail),
        borderRadius: BorderRadius.circular(AppRadius.radiusLg),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.spacingLg),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.white.withValues(alpha: 0.3),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.group,
                  color: AppColors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: AppSpacing.spacingMd),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      group.name,
                      style: AppTypography.h6(color: AppColors.white),
                    ),
                    Text(
                      '${group.progress}% complete',
                      style: AppTypography.bodySmall(color: AppColors.white),
                    ),
                  ],
                ),
              ),
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: AppColors.white,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: group.isPrimary
                      ? AppColors.neutral600
                      : AppColors.brandSecondary600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
