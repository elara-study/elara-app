import 'dart:math' as math;
import 'dart:ui';
import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_radius.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:elara/features/student/domain/rewards/entities/badge_entity.dart';
import 'package:elara/core/localization/localization_extension.dart';
import 'package:flutter/material.dart';

class BadgeCelebrationOverlay extends StatefulWidget {
  final BadgeEntity badge;
  final VoidCallback onDismiss;

  const BadgeCelebrationOverlay({
    super.key,
    required this.badge,
    required this.onDismiss,
  });

  @override
  State<BadgeCelebrationOverlay> createState() => _BadgeCelebrationOverlayState();
}

class _BadgeCelebrationOverlayState extends State<BadgeCelebrationOverlay>
    with TickerProviderStateMixin {
  late AnimationController _entryController;
  late AnimationController _rotationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  
  // Confetti particles
  final List<_ConfettiParticle> _particles = [];

  @override
  void initState() {
    super.initState();
    _entryController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _rotationController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: const Interval(0.1, 0.8, curve: Curves.elasticOut),
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: const Interval(0.0, 0.4, curve: Curves.easeIn),
      ),
    );

    // Initialize particles
    final random = math.Random();
    for (int i = 0; i < 40; i++) {
      _particles.add(
        _ConfettiParticle(
          color: HSVColor.fromAHSV(
            1.0,
            random.nextDouble() * 360,
            0.7,
            0.9,
          ).toColor(),
          angle: random.nextDouble() * 2 * math.pi,
          speed: 1.5 + random.nextDouble() * 3.5,
          scale: 4.0 + random.nextDouble() * 8.0,
          rotationSpeed: (random.nextDouble() - 0.5) * 5,
        ),
      );
    }

    _entryController.forward();
  }

  @override
  void dispose() {
    _entryController.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  IconData _getIconData(String iconKey) {
    switch (iconKey) {
      case 'book':
      case 'lesson':
        return Icons.auto_stories_rounded;
      case 'bolt':
        return Icons.bolt_rounded;
      case 'fire':
      case 'streak':
        return Icons.local_fire_department_rounded;
      case 'crown':
      case 'star':
        return Icons.emoji_events_rounded;
      case 'bookworm':
        return Icons.menu_book_rounded;
      case 'genius':
        return Icons.psychology_rounded;
      case 'calendar':
        return Icons.calendar_today_rounded;
      case 'legend':
      case 'medal':
      default:
        return Icons.military_tech_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final iconData = _getIconData(widget.badge.iconKey);

    return AnimatedBuilder(
      animation: _entryController,
      builder: (context, child) {
        return Opacity(
          opacity: _fadeAnimation.value,
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Glass backdrop filter
              Positioned.fill(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                  child: Container(
                    color: Colors.black.withValues(alpha: 0.85),
                  ),
                ),
              ),
              
              // Animated Confetti
              ..._particles.map((p) {
                final progress = Curves.easeOutCubic.transform(_entryController.value);
                final offset = Offset(
                  math.cos(p.angle) * p.speed * 180 * progress,
                  math.sin(p.angle) * p.speed * 180 * progress + (progress * 120),
                );
                final rotation = p.rotationSpeed * progress * 2 * math.pi;

                return Center(
                  child: Transform.translate(
                    offset: offset,
                    child: Transform.rotate(
                      angle: rotation,
                      child: Container(
                        width: p.scale,
                        height: p.scale,
                        decoration: BoxDecoration(
                          color: p.color,
                          shape: p.scale % 3 == 0
                              ? BoxShape.rectangle
                              : BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                );
              }),

              // Central Celebration Content
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.spacing2xl),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          AnimatedBuilder(
                            animation: _rotationController,
                            builder: (context, child) {
                              return Transform.rotate(
                                angle: _rotationController.value * 2 * math.pi,
                                child: Container(
                                  width: 260,
                                  height: 260,
                                  decoration: BoxDecoration(
                                    gradient: RadialGradient(
                                      colors: [
                                        AppColors.brandPrimary500.withValues(alpha: 0.25),
                                        AppColors.brandSecondary500.withValues(alpha: 0.1),
                                        Colors.transparent,
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                          ScaleTransition(
                            scale: _scaleAnimation,
                            child: Container(
                              width: 140,
                              height: 140,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: const LinearGradient(
                                  colors: [
                                    AppColors.brandPrimary400,
                                    AppColors.brandSecondary500,
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.brandPrimary500.withValues(alpha: 0.6),
                                    blurRadius: 30,
                                    spreadRadius: 5,
                                  )
                                ],
                              ),
                              child: Icon(
                                iconData,
                                size: 72,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.spacing2xl),
                      ScaleTransition(
                        scale: _scaleAnimation,
                        child: Column(
                          children: [
                            Text(
                              context.l10n.rewardsNewBadgeUnlocked,
                              textAlign: TextAlign.center,
                              style: AppTypography.labelLarge(
                                color: AppColors.brandSecondary400,
                              ).copyWith(
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.spacingSm),
                            Text(
                              widget.badge.name,
                              textAlign: TextAlign.center,
                              style: AppTypography.h2(color: Colors.white).copyWith(
                                fontWeight: AppTypography.extraBold,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.spacingMd),
                            Text(
                              widget.badge.description,
                              textAlign: TextAlign.center,
                              style: AppTypography.bodyLarge(
                                color: Colors.white.withValues(alpha: 0.8),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 48),
                      // Dismiss Button
                      ScaleTransition(
                        scale: _scaleAnimation,
                        child: ElevatedButton(
                          onPressed: () async {
                            await _entryController.reverse();
                            widget.onDismiss();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: AppColors.neutral900,
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.spacing3xl,
                              vertical: AppSpacing.spacingMd,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AppRadius.radiusFull),
                            ),
                            elevation: 8,
                          ),
                          child: Text(
                            context.l10n.rewardsAwesome,
                            style: AppTypography.labelLarge(color: AppColors.neutral900).copyWith(
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.1,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ConfettiParticle {
  final Color color;
  final double angle;
  final double speed;
  final double scale;
  final double rotationSpeed;

  _ConfettiParticle({
    required this.color,
    required this.angle,
    required this.speed,
    required this.scale,
    required this.rotationSpeed,
  });
}
