import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_radius.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:elara/core/theme/app_shadows.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class QuizResultsRewardCard extends StatefulWidget {
  const QuizResultsRewardCard({
    super.key,
    required this.xpEarned,
    required this.totalScoreXp,
    required this.level,
    required this.levelProgress,
    required this.streakDays,
  });

  final int xpEarned;
  final int totalScoreXp;
  final int level;
  final double levelProgress;
  final int streakDays;

  @override
  State<QuizResultsRewardCard> createState() => _QuizResultsRewardCardState();
}

class _QuizResultsRewardCardState extends State<QuizResultsRewardCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _bouncingXp;
  late Animation<int> _xpEarnedCount;
  late Animation<int> _totalXpCount;
  late Animation<double> _progressBarFill;
  late Animation<double> _streakPulse;

  static final _xpFmt = NumberFormat.decimalPattern();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    // Bouncing scale for the "+XP" text
    _bouncingXp = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
      ),
    );

    // XP earned count-up
    _xpEarnedCount = IntTween(begin: 0, end: widget.xpEarned).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.1, 0.8, curve: Curves.easeOut),
      ),
    );

    // Total XP count-up (starting from before this quiz's XP was earned)
    final startTotalXp = (widget.totalScoreXp - widget.xpEarned).clamp(0, widget.totalScoreXp);
    _totalXpCount = IntTween(begin: startTotalXp, end: widget.totalScoreXp).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.1, 0.8, curve: Curves.easeOut),
      ),
    );

    // Progress bar fill starting from previous level progress to current
    final startProgress = (startTotalXp % 120) / 120.0;
    _progressBarFill = Tween<double>(
      begin: startProgress,
      end: widget.levelProgress,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 0.9, curve: Curves.easeInOut),
      ),
    );

    // Streak badge pulse/glow animation
    _streakPulse = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 1.2), weight: 30),
      TweenSequenceItem(tween: Tween<double>(begin: 1.2, end: 0.95), weight: 30),
      TweenSequenceItem(tween: Tween<double>(begin: 0.95, end: 1.05), weight: 20),
      TweenSequenceItem(tween: Tween<double>(begin: 1.05, end: 1.0), weight: 20),
    ]).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 0.9, curve: Curves.easeInOut),
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final secondary = isDark
        ? DarkModeColors.textSecondary
        : LightModeColors.textSecondary;
    final onSurface = theme.colorScheme.onSurface;
    final surface = isDark ? AppColors.neutral800 : theme.colorScheme.surface;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.spacing2xl),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(AppRadius.radiusLg),
        boxShadow: AppShadows.elevation(theme.brightness),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'REWARD EARNED',
            style: AppTypography.labelRegular(color: secondary),
          ),
          const SizedBox(height: AppSpacing.spacingMd),
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return ScaleTransition(
                scale: _bouncingXp,
                child: Text(
                  '+${_xpFmt.format(_xpEarnedCount.value)} XP',
                  textAlign: TextAlign.center,
                  style: AppTypography.h2(color: AppColors.brandPrimary500).copyWith(
                    fontSize: 36,
                    fontWeight: AppTypography.extraBold,
                    height: 1.22,
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: AppSpacing.spacingMd),
          Center(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Transform.scale(
                  scale: _streakPulse.value,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.spacingMd,
                      vertical: AppSpacing.spacingSm,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.brandSecondary500Alpha10,
                      borderRadius: BorderRadius.circular(AppRadius.radiusFull),
                      boxShadow: _streakPulse.value > 1.05
                          ? [
                              BoxShadow(
                                color: AppColors.brandSecondary500.withValues(alpha: 0.3),
                                blurRadius: 10,
                                spreadRadius: 2,
                              )
                            ]
                          : null,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.local_fire_department_rounded,
                          size: 16,
                          color: AppColors.brandSecondary500,
                        ),
                        const SizedBox(width: AppSpacing.spacingXs),
                        Text(
                          'STREAK: ${widget.streakDays} DAYS',
                          style: AppTypography.labelRegular(
                            color: AppColors.brandSecondary500,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: AppSpacing.spacingLg),
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'TOTAL SCORE: ${_xpFmt.format(_totalXpCount.value)} XP',
                          style: AppTypography.labelRegular(color: onSurface),
                        ),
                      ),
                      Text(
                        'LEVEL ${widget.level}',
                        style: AppTypography.labelRegular(color: onSurface),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.spacingXs),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(AppRadius.radiusFull),
                    child: SizedBox(
                      height: 8,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          ColoredBox(
                            color: AppColors.brandPrimary100.withValues(alpha: 0.5),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: FractionallySizedBox(
                              widthFactor: _progressBarFill.value.clamp(0.0, 1.0),
                              child: const ColoredBox(color: AppColors.brandPrimary700),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
