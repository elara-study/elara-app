import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_radius.dart';
import 'package:flutter/material.dart';

class SegmentedProgressBar extends StatelessWidget {
  const SegmentedProgressBar({
    super.key,
    required this.progress,
    this.height = 8,
    this.trackColor,
  });

  /// 0.0–1.0
  final double progress;
  final double height;

  final Color? trackColor;

  @override
  Widget build(BuildContext context) {
    final track = trackColor ?? AppColors.brandPrimary100;
    final t = progress.clamp(0.0, 1.0);

    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.radiusFull),
      child: SizedBox(
        height: height,
        child: Stack(
          fit: StackFit.expand,
          children: [
            ColoredBox(color: track),
            Align(
              alignment: Alignment.centerLeft,
              child: FractionallySizedBox(
                widthFactor: t,
                heightFactor: 1,
                alignment: Alignment.centerLeft,
                child: const ColoredBox(color: AppColors.brandPrimary700),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
