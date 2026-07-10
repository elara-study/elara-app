import 'package:elara/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

/// One soft circular highlight.
///
/// [left]/[right]/[top]/[bottom] and [diameter] use **logical pixels**, matching
/// [GroupProgressCard] so glow layout stays consistent across screens.
/// [opacity] is applied to [tint] (`tint.withValues(alpha: opacity)`).
class GlowOrb {
  const GlowOrb({
    this.left,
    this.right,
    this.top,
    this.bottom,
    required this.opacity,
    this.diameter = 128,
  });

  final double? left;
  final double? right;
  final double? top;
  final double? bottom;
  final double opacity;
  final double diameter;
}

/// Tints for glow orbs — pick one that matches the gradient underneath.
abstract final class GradientGlowTints {
  /// White veil on strong coloured gradients (e.g. compact list rows).
  static const Color whiteVeil = AppColors.white;

  /// Light brand wash on primary hero gradients (e.g. Continue Learning).
  static const Color brandWash = AppColors.brandPrimary50;
}

/// Preset orb layouts — **groupProgress** matches [GroupProgressCard] exactly.
abstract final class GradientGlowOrbs {
  /// Student group progress card: two 128px orbs at fixed corners (canonical).
  static const List<GlowOrb> groupProgress = [
    GlowOrb(top: -74, right: -64, opacity: 0.15),
    GlowOrb(bottom: -76, left: -64, opacity: 0.15),
  ];

  /// Continue Learning hero — same orbs as [groupProgress].
  static const List<GlowOrb> courseHero = groupProgress;

  /// Home "My Groups" horizontal cards: one **left** white veil — not the
  /// [groupProgress] corner layout (that stays on group progress / Continue Learning).
  static const List<GlowOrb> actionListRow = [
    GlowOrb(left: -20, top: -20, opacity: 0.15),
  ];
}

/// Paints [GlowOrb]s behind content; [tint] is usually [GradientGlowTints].
///
/// Must receive **bounded** constraints (e.g. wrap in [Positioned.fill] when
/// this layer sits in a [Stack] whose height is otherwise unbounded).
class GlowOrbLayer extends StatelessWidget {
  const GlowOrbLayer({super.key, required this.tint, required this.orbs});

  final Color tint;
  final List<GlowOrb> orbs;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        for (final o in orbs)
          Positioned(
            left: o.left,
            right: o.right,
            top: o.top,
            bottom: o.bottom,
            child: IgnorePointer(
              child: Container(
                width: o.diameter,
                height: o.diameter,
                decoration: BoxDecoration(
                  color: tint.withValues(alpha: o.opacity),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

/// Clips [child] and draws glow orbs underneath — use inside a [Container]
/// whose [BoxDecoration] already defines the gradient and matching radii.
class GradientGlowClipStack extends StatelessWidget {
  const GradientGlowClipStack({
    super.key,
    required this.borderRadius,
    required this.glowTint,
    required this.glowOrbs,
    required this.child,
  });

  final BorderRadius borderRadius;
  final Color glowTint;
  final List<GlowOrb> glowOrbs;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      clipBehavior: Clip.antiAlias,
      child: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          Positioned.fill(
            child: GlowOrbLayer(tint: glowTint, orbs: glowOrbs),
          ),
          child,
        ],
      ),
    );
  }
}

/// Full-width gradient card with shared glow treatment.
class GradientGlowCard extends StatelessWidget {
  const GradientGlowCard({
    super.key,
    required this.borderRadius,
    required this.gradient,
    this.boxShadow = const <BoxShadow>[],
    required this.glowTint,
    required this.glowOrbs,
    required this.child,
  });

  final BorderRadius borderRadius;
  final Gradient gradient;
  final List<BoxShadow> boxShadow;
  final Color glowTint;
  final List<GlowOrb> glowOrbs;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: borderRadius,
        boxShadow: boxShadow,
      ),
      child: GradientGlowClipStack(
        borderRadius: borderRadius,
        glowTint: glowTint,
        glowOrbs: glowOrbs,
        child: child,
      ),
    );
  }
}
