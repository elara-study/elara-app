import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/features/student/presentation/voice/cubit/voice_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class VoiceOrb extends StatefulWidget {
  const VoiceOrb({
    super.key,
    required this.status,
    required this.amplitude,
  });

  final VoiceStatus status;
  final double amplitude;

  @override
  State<VoiceOrb> createState() => _VoiceOrbState();
}

class _VoiceOrbState extends State<VoiceOrb>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _glowController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void didUpdateWidget(VoiceOrb oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.status == VoiceStatus.speaking) {
      _glowController.duration = const Duration(milliseconds: 800);
    } else {
      _glowController.duration = const Duration(milliseconds: 2000);
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  Color _glowColor() {
    switch (widget.status) {
      case VoiceStatus.idle:
        return AppColors.brandPrimary500;
      case VoiceStatus.connecting:
        return AppColors.brandPrimary300;
      case VoiceStatus.listening:
        return AppColors.success500;
      case VoiceStatus.transcribing:
        return AppColors.brandAccent500;
      case VoiceStatus.thinking:
        return AppColors.brandAccent500;
      case VoiceStatus.speaking:
        return AppColors.brandSecondary500;
      case VoiceStatus.paused:
        return AppColors.neutral500;
      case VoiceStatus.error:
        return AppColors.error500;
    }
  }

  @override
  Widget build(BuildContext context) {
    final glowColor = _glowColor();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: Listenable.merge([_pulseController, _glowController]),
      builder: (context, child) {
        final pulseScale = _pulseAnimation.value;
        final amplitudeBoost = widget.status == VoiceStatus.listening
            ? 1.0 + (widget.amplitude * 0.15)
            : 1.0;
        final totalScale = pulseScale * amplitudeBoost;
        final glowIntensity = _glowController.value;

        return Transform.scale(
          scale: totalScale,
          child: SizedBox(
            width: 180,
            height: 180,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Glow layers underneath
                ...List.generate(3, (i) {
                  final spread = (i + 1) * 15.0;
                  final opacity = (0.15 - i * 0.04) * (0.7 + glowIntensity * 0.3);
                  return Container(
                    width: 120 + spread * 2,
                    height: 120 + spread * 2,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: glowColor.withValues(alpha: opacity),
                          blurRadius: spread + glowIntensity * 10,
                          spreadRadius: spread * 0.5,
                        ),
                      ],
                    ),
                  );
                }),

                // Logo with glow background
                SizedBox(
                  width: 120,
                  height: 120,
                  child: CustomPaint(
                    painter: _LogoGlowPainter(
                      glowColor: glowColor,
                      glowIntensity: glowIntensity,
                      isDark: isDark,
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        'assets/images/logo.svg',
                        width: 80,
                        height: 80,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _LogoGlowPainter extends CustomPainter {
  _LogoGlowPainter({
    required this.glowColor,
    required this.glowIntensity,
    required this.isDark,
  });

  final Color glowColor;
  final double glowIntensity;
  final bool isDark;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Background circle with glow
    final bgPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          glowColor.withValues(alpha: 0.15 + glowIntensity * 0.1),
          glowColor.withValues(alpha: 0.05),
          Colors.transparent,
        ],
        stops: const [0.0, 0.6, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: radius));

    canvas.drawCircle(center, radius, bgPaint);

    // Subtle border ring
    final ringPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          glowColor.withValues(alpha: 0.3 + glowIntensity * 0.15),
          glowColor.withValues(alpha: 0.1),
        ],
      ).createShader(
        Rect.fromCircle(center: center, radius: radius),
      )
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    canvas.drawCircle(center, radius - 1, ringPaint);
  }

  @override
  bool shouldRepaint(_LogoGlowPainter oldDelegate) {
    return oldDelegate.glowColor != glowColor ||
        oldDelegate.glowIntensity != glowIntensity;
  }
}
