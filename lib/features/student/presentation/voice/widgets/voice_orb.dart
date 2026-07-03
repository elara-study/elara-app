import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/features/student/presentation/voice/cubit/voice_state.dart';
import 'package:flutter/material.dart';

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
  late AnimationController _scaleController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );
  }

  @override
  void didUpdateWidget(VoiceOrb oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.status == VoiceStatus.speaking) {
      _scaleController.repeat(reverse: true);
    } else {
      _scaleController.stop();
      _scaleController.reset();
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _scaleController.dispose();
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
    final size = 160.0;

    return AnimatedBuilder(
      animation: Listenable.merge([_pulseController, _scaleController]),
      builder: (context, child) {
        final pulseScale = _pulseAnimation.value;
        final bounceScale = _scaleAnimation.value;
        final amplitudeBoost = widget.status == VoiceStatus.listening
            ? 1.0 + (widget.amplitude * 0.2)
            : 1.0;
        final totalScale = pulseScale * bounceScale * amplitudeBoost;

        return Transform.scale(
          scale: totalScale,
          child: SizedBox(
            width: size,
            height: size,
            child: CustomPaint(
              painter: _OrbPainter(
                glowColor: glowColor,
                amplitude: widget.amplitude,
                status: widget.status,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _OrbPainter extends CustomPainter {
  _OrbPainter({
    required this.glowColor,
    required this.amplitude,
    required this.status,
  });

  final Color glowColor;
  final double amplitude;
  final VoiceStatus status;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Outer glow
    final glowPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          glowColor.withValues(alpha: 0.4),
          glowColor.withValues(alpha: 0.1),
          glowColor.withValues(alpha: 0.0),
        ],
        stops: const [0.5, 0.75, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: radius));

    canvas.drawCircle(center, radius, glowPaint);

    // Mid glow ring
    final ringPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          glowColor.withValues(alpha: 0.6),
          glowColor.withValues(alpha: 0.2),
        ],
      ).createShader(
        Rect.fromCircle(center: center, radius: radius * 0.7),
      )
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    canvas.drawCircle(center, radius * 0.7, ringPaint);

    // Inner orb gradient
    final orbPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          _lighten(glowColor, 0.3),
          glowColor,
          _darken(glowColor, 0.2),
        ],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(
        Rect.fromCircle(center: center, radius: radius * 0.5),
      );

    canvas.drawCircle(center, radius * 0.5, orbPaint);

    // Highlight
    final highlightPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          Colors.white.withValues(alpha: 0.3),
          Colors.white.withValues(alpha: 0.0),
        ],
      ).createShader(
        Rect.fromCircle(
          center: center + Offset(-radius * 0.15, -radius * 0.15),
          radius: radius * 0.25,
        ),
      );

    canvas.drawCircle(
      center + Offset(-radius * 0.15, -radius * 0.15),
      radius * 0.25,
      highlightPaint,
    );
  }

  Color _lighten(Color color, double amount) {
    final hsl = HSLColor.fromColor(color);
    final lightened =
        hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));
    return lightened.toColor();
  }

  Color _darken(Color color, double amount) {
    final hsl = HSLColor.fromColor(color);
    final darkened =
        hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    return darkened.toColor();
  }

  @override
  bool shouldRepaint(_OrbPainter oldDelegate) {
    return oldDelegate.glowColor != glowColor ||
        oldDelegate.amplitude != amplitude ||
        oldDelegate.status != status;
  }
}
