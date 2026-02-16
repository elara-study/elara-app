import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_radius.dart';
import 'package:flutter/material.dart';

/// Layout: both corners (default) or single circle on left.
enum CardCircleLayout { both, leftOnly }

/// Card with decorative circles at edges (light opacity) - rounded box style.
/// Circles are a lighter shade overlay, clipped by card bounds.
/// Use [gradient] for a gradient background, or [backgroundColor] for a solid color.
/// Use [circleLayout] for both corners (default) or [CardCircleLayout.leftOnly] for one circle on the left.
class CardWithCircleBackground extends StatelessWidget {
  const CardWithCircleBackground({
    super.key,
    this.backgroundColor,
    this.gradient,
    required this.child,
    this.circleLayout = CardCircleLayout.both,
  }) : assert(
         backgroundColor != null || gradient != null,
         'Provide either backgroundColor or gradient',
       );

  final Color? backgroundColor;
  final Gradient? gradient;
  final Widget child;
  final CardCircleLayout circleLayout;

  @override
  Widget build(BuildContext context) {
    const radius = AppRadius.radiusLg;
    final circleColor = AppColors.primary50.withValues(alpha: 0.15);

    final circles = <Widget>[
      if (circleLayout == CardCircleLayout.both)
        Positioned(
          top: -50,
          right: -50,
          child: _Circle(color: circleColor, size: 128),
        ),
      if (circleLayout == CardCircleLayout.both)
        Positioned(
          bottom: -60,
          left: -60,
          child: _Circle(color: circleColor, size: 128),
        ),
      if (circleLayout == CardCircleLayout.leftOnly)
        Positioned(
          bottom: -30,
          left: -30,
          child: _Circle(color: circleColor, size: 128),
        ),
    ];

    return Container(
      decoration: BoxDecoration(
        color: gradient == null ? backgroundColor : null,
        gradient: gradient,
        borderRadius: BorderRadius.circular(radius),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.topLeft,
          children: [...circles, child],
        ),
      ),
    );
  }
}

class _Circle extends StatelessWidget {
  const _Circle({required this.color, required this.size});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      ),
    );
  }
}
