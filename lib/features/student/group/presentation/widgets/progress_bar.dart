import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:elara/shared/widgets/segmented_progress_bar.dart';
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
        SegmentedProgressBar(progress: progress, height: AppSpacing.spacingSm),
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
