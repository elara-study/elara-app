import 'package:elara/core/theme/app_radius.dart';
import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_shadows.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:elara/features/student/group/presentation/widgets/progress_bar.dart';
import 'package:elara/shared/widgets/gradient_glow_card.dart';
import 'package:flutter/material.dart';

class GroupProgressCard extends StatelessWidget {
  final String completedLabel;
  final double progress; // 0..1

  const GroupProgressCard({
    super.key,
    required this.completedLabel,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final clamped = progress.clamp(0.0, 1.0);

    final gradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [cs.primaryContainer, cs.primaryFixedDim],
    );
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.radiusLg),
        boxShadow: AppShadows.elevation(theme.brightness),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.radiusLg),
        child: Stack(
          clipBehavior: Clip.hardEdge,
          children: [
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(gradient: gradient),
              ),
            ),
            const Positioned.fill(
              child: GlowOrbLayer(
                tint: GradientGlowTints.brandWash,
                orbs: GradientGlowOrbs.groupProgress,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.spacingLg,
                AppSpacing.spacing3xl,
                AppSpacing.spacing2xl,
                AppSpacing.spacingLg,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Your Group Progress',
                    style: AppTypography.h4(color: AppColors.neutral50),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppSpacing.spacingLg),
                  ProgressBar(
                    completedLabel: completedLabel,
                    percentLabel: '${(clamped * 100).round()}%',
                    progress: clamped,
                  ),
                  const SizedBox(height: AppSpacing.spacing2xl),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
