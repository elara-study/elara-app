import 'dart:math' as math;
import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_radius.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:elara/features/student/domain/dashboard/entities/daily_goal_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:elara/core/theme/app_spacing.dart';

class DailyGoalItem extends StatefulWidget {
  final DailyGoalEntity goal;

  const DailyGoalItem({
    super.key,
    required this.goal,
  });

  @override
  State<DailyGoalItem> createState() => _DailyGoalItemState();
}

class _DailyGoalItemState extends State<DailyGoalItem> with TickerProviderStateMixin {
  late AnimationController _completionController;
  late Animation<double> _iconScale;
  late AnimationController _particleController;
  final List<_MiniParticle> _particles = [];
  double _strikethroughFactor = 0.0;

  @override
  void initState() {
    super.initState();
    _completionController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _iconScale = Tween<double>(begin: 1.0, end: 1.0).animate(_completionController);

    _particleController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _strikethroughFactor = widget.goal.isCompleted ? 1.0 : 0.0;

    if (widget.goal.isCompleted) {
      _completionController.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(DailyGoalItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!oldWidget.goal.isCompleted && widget.goal.isCompleted) {
      setState(() {
        _strikethroughFactor = 1.0;
      });
      _completionController.reset();
      _iconScale = TweenSequence<double>([
        TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 0.6), weight: 30),
        TweenSequenceItem(tween: Tween<double>(begin: 0.6, end: 1.3), weight: 40),
        TweenSequenceItem(tween: Tween<double>(begin: 1.3, end: 1.0), weight: 30),
      ]).animate(
        CurvedAnimation(parent: _completionController, curve: Curves.easeOut),
      );
      _completionController.forward();

      _generateParticles();
      _particleController.reset();
      _particleController.forward();
    } else if (oldWidget.goal.isCompleted && !widget.goal.isCompleted) {
      setState(() {
        _strikethroughFactor = 0.0;
      });
      _completionController.value = 0.0;
    }
  }

  void _generateParticles() {
    _particles.clear();
    final random = math.Random();
    final colors = [
      AppColors.brandSecondary500,
      AppColors.brandPrimary500,
      Colors.green,
      Colors.amber,
      Colors.purple,
    ];
    for (int i = 0; i < 15; i++) {
      final angle = random.nextDouble() * 2 * math.pi;
      final speed = 2.0 + random.nextDouble() * 3.0;
      _particles.add(
        _MiniParticle(
          color: colors[random.nextInt(colors.length)],
          angle: angle,
          speed: speed,
          size: 3.0 + random.nextDouble() * 4.0,
        ),
      );
    }
  }

  @override
  void dispose() {
    _completionController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  String get _iconAsset => widget.goal.isCompleted
      ? 'assets/icons/rewards_icon.svg'
      : 'assets/icons/flag_icon.svg';

  double get _barProgress {
    if (widget.goal.isCompleted) return 1.0;
    if (widget.goal.progressTotal <= 0) return 0.0;
    return (widget.goal.progressCurrent / widget.goal.progressTotal).clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final iconColor = widget.goal.isCompleted
        ? AppColors.brandSecondary500
        : cs.onSurfaceVariant;
    final iconBg = widget.goal.isCompleted
        ? AppColors.brandSecondary500.withValues(alpha: 0.20)
        : cs.surfaceContainerHighest;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              AnimatedBuilder(
                animation: _completionController,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _iconScale.value,
                    child: Container(
                      width: 44.w,
                      height: 44.h,
                      decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
                      child: Center(
                        child: SvgPicture.asset(
                          _iconAsset,
                          width: 15.w,
                          height: 15.w,
                          colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
                        ),
                      ),
                    ),
                  );
                },
              ),
              AnimatedBuilder(
                animation: _particleController,
                builder: (context, child) {
                  if (!_particleController.isAnimating) return const SizedBox.shrink();
                  final progress = _particleController.value;
                  return Stack(
                    clipBehavior: Clip.none,
                    children: _particles.map((p) {
                      final distance = p.speed * 30 * progress;
                      final dx = math.cos(p.angle) * distance;
                      final dy = math.sin(p.angle) * distance;
                      final opacity = (1.0 - progress).clamp(0.0, 1.0);

                      return Positioned(
                        left: dx + 22.w - (p.size / 2),
                        top: dy + 22.h - (p.size / 2),
                        child: Opacity(
                          opacity: opacity,
                          child: Container(
                            width: p.size,
                            height: p.size,
                            decoration: BoxDecoration(
                              color: p.color,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ],
          ),

          SizedBox(width: AppSpacing.spacingMd.w),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    Text(
                      widget.goal.label,
                      style: AppTypography.bodyMedium(
                        color: widget.goal.isCompleted ? cs.onSurfaceVariant : cs.onSurface,
                      ),
                    ),
                    if (widget.goal.isCompleted)
                      Positioned(
                        left: 0,
                        right: 0,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: AnimatedFractionallySizedBox(
                            duration: const Duration(milliseconds: 500),
                            widthFactor: _strikethroughFactor,
                            child: Container(
                              height: 1.5,
                              color: cs.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),

                SizedBox(height: AppSpacing.spacingXs.h),

                TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 0.0, end: _barProgress),
                  duration: const Duration(milliseconds: 600),
                  builder: (context, val, child) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(AppRadius.radiusFull.r),
                      child: LinearProgressIndicator(
                        value: val,
                        minHeight: AppSpacing.spacingSm.h,
                        backgroundColor: cs.surfaceContainerHighest,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          AppColors.brandPrimary700,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          SizedBox(width: AppSpacing.spacingMd.w),

          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                'assets/icons/electric_icon.svg',
                width: AppSpacing.spacingLg.w,
                height: AppSpacing.spacingLg.h,
                colorFilter: const ColorFilter.mode(
                  AppColors.brandSecondary500,
                  BlendMode.srcIn,
                ),
              ),
              SizedBox(width: AppSpacing.spacingXs.w),
              Text(
                '+${widget.goal.xpReward}',
                style: AppTypography.labelRegular(
                  color: AppColors.brandSecondary500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MiniParticle {
  final Color color;
  final double angle;
  final double speed;
  final double size;

  _MiniParticle({
    required this.color,
    required this.angle,
    required this.speed,
    required this.size,
  });
}
