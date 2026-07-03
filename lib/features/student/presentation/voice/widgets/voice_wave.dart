import 'dart:math' as math;

import 'package:elara/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class VoiceWave extends StatefulWidget {
  const VoiceWave({
    super.key,
    required this.amplitude,
    required this.isActive,
  });

  final double amplitude;
  final bool isActive;

  @override
  State<VoiceWave> createState() => _VoiceWaveState();
}

class _VoiceWaveState extends State<VoiceWave>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final int _barCount = 32;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return SizedBox(
          height: 80,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: List.generate(_barCount, (i) {
              final normalizedPosition = i / _barCount;
              final centerDistance =
                  (normalizedPosition - 0.5).abs() * 2;

              double height;
              if (widget.isActive) {
                final wave =
                    math.sin((_controller.value * 2 * math.pi) + (i * 0.5));
                final baseHeight = 0.2 + (1 - centerDistance) * 0.3;
                final amplitudeEffect = widget.amplitude * (1 - centerDistance * 0.5);
                height = (baseHeight + wave * 0.15 + amplitudeEffect * 0.5)
                    .clamp(0.05, 1.0);
              } else {
                height = 0.05;
              }

              final barColor = widget.isActive
                  ? (isDark
                      ? AppColors.brandPrimary300
                          .withValues(alpha: 0.3 + (1 - centerDistance) * 0.5)
                      : AppColors.brandPrimary500
                          .withValues(alpha: 0.3 + (1 - centerDistance) * 0.5))
                  : (isDark ? AppColors.neutral600 : AppColors.neutral300);

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 1.5),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 100),
                  width: 3,
                  height: height * 60,
                  decoration: BoxDecoration(
                    color: barColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              );
            }),
          ),
        );
      },
    );
  }
}
