import 'package:elara/core/theme/app_radius.dart';
import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:elara/features/student/group/presentation/widgets/progress_bar.dart';
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
    final cs = Theme.of(context).colorScheme;
    final clamped = progress.clamp(0.0, 1.0);

    final gradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [cs.primaryContainer, cs.primaryFixedDim],
    );
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.radiusLg),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.10),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
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
            const _GlowCircle(
              size: 128,
              top: -74,
              right: -64,
              solidFill: AppColors.brandPrimary50,
              layerOpacity: 0.15,
            ),
            const _GlowCircle(
              size: 128,
              bottom: -76,
              left: -64,
              solidFill: AppColors.brandPrimary50,
              layerOpacity: 0.15,
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

class _GlowCircle extends StatelessWidget {
  final double size;
  final double? top;
  final double? left;
  final double? right;
  final double? bottom;
  final Color solidFill;
  final double layerOpacity;

  const _GlowCircle({
    required this.size,
    this.top,
    this.left,
    this.right,
    this.bottom,
    required this.solidFill,
    required this.layerOpacity,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      left: left,
      right: right,
      bottom: bottom,
      child: IgnorePointer(
        child: SizedBox(
          width: size,
          height: size,
          child: Opacity(
            opacity: layerOpacity,
            child: DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: solidFill,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
