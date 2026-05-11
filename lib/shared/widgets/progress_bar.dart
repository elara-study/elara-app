import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:elara/shared/widgets/segmented_progress_bar.dart';
import 'package:flutter/material.dart';

/// Row of labels plus a [SegmentedProgressBar] for a 0..1 [progress] value.
class ProgressBar extends StatelessWidget {
  const ProgressBar({
    super.key,
    required this.completedLabel,
    required this.percentLabel,
    required this.progress,
    this.metaLabelColor,
    this.completedLabelColor,
    this.percentLabelColor,
    this.barHeight,
    this.trackColor,
  });

  final String completedLabel;
  final String percentLabel;

  /// 0..1
  final double progress;

  /// Default color for both meta labels when per-side colors are null.
  final Color? metaLabelColor;

  /// Overrides [metaLabelColor] for [completedLabel] only.
  final Color? completedLabelColor;

  /// Overrides [metaLabelColor] for [percentLabel] only.
  final Color? percentLabelColor;

  /// Bar height; defaults to [AppSpacing.spacingSm].
  final double? barHeight;

  /// Track fill behind the filled segment; see [SegmentedProgressBar.trackColor].
  final Color? trackColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _MetaRow(
          completedLabel: completedLabel,
          percentLabel: percentLabel,
          metaLabelColor: metaLabelColor,
          completedLabelColor: completedLabelColor,
          percentLabelColor: percentLabelColor,
        ),
        const SizedBox(height: AppSpacing.spacingXs),
        SegmentedProgressBar(
          progress: progress,
          height: barHeight ?? AppSpacing.spacingSm,
          trackColor: trackColor,
        ),
      ],
    );
  }
}

class _MetaRow extends StatelessWidget {
  const _MetaRow({
    required this.completedLabel,
    required this.percentLabel,
    this.metaLabelColor,
    this.completedLabelColor,
    this.percentLabelColor,
  });

  final String completedLabel;
  final String percentLabel;
  final Color? metaLabelColor;
  final Color? completedLabelColor;
  final Color? percentLabelColor;

  @override
  Widget build(BuildContext context) {
    final fallback = metaLabelColor ?? AppColors.neutral50;
    final left = completedLabelColor ?? fallback;
    final right = percentLabelColor ?? fallback;
    return Row(
      children: [
        Expanded(
          child: Text(
            completedLabel,
            style: AppTypography.bodyMedium(color: left),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Text(percentLabel, style: AppTypography.bodyMedium(color: right)),
      ],
    );
  }
}
