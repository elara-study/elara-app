import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_radius.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:flutter/material.dart';

class ProgressBar extends StatelessWidget {
  final String completedLabel;
  final String percentLabel;
  final double progress; // 0..1
  /// Null: meta labels use [AppColors.neutral50]. Else this color.
  final Color? metaLabelColor;

  const ProgressBar({
    super.key,
    required this.completedLabel,
    required this.percentLabel,
    required this.progress,
    this.metaLabelColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _MetaRow(
          completedLabel: completedLabel,
          percentLabel: percentLabel,
          metaLabelColor: metaLabelColor,
        ),
        const SizedBox(height: AppSpacing.spacingXs),
        _Bar(progress: progress),
      ],
    );
  }
}

class _MetaRow extends StatelessWidget {
  final String completedLabel;
  final String percentLabel;
  final Color? metaLabelColor;

  const _MetaRow({
    required this.completedLabel,
    required this.percentLabel,
    this.metaLabelColor,
  });

  @override
  Widget build(BuildContext context) {
    final color = metaLabelColor ?? AppColors.neutral50;
    return Row(
      children: [
        Text(completedLabel, style: AppTypography.bodyMedium(color: color)),
        const Spacer(),
        Text(percentLabel, style: AppTypography.bodyMedium(color: color)),
      ],
    );
  }
}

class _Bar extends StatelessWidget {
  final double progress;

  const _Bar({required this.progress});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.radiusFull),
      child: SizedBox(
        height: AppSpacing.spacingSm,
        child: Stack(
          fit: StackFit.expand,
          children: [
            const ColoredBox(color: AppColors.brandPrimary100),
            FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: progress.clamp(0.0, 1.0),
              child: const ColoredBox(color: AppColors.brandPrimary700),
            ),
          ],
        ),
      ),
    );
  }
}
