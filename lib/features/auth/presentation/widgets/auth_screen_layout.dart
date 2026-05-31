import 'dart:math' as math;

import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/features/auth/presentation/widgets/auth_screen_metrics.dart';
import 'package:flutter/material.dart';

/// Shared layout shell used by every auth screen.
class AuthScreenLayout extends StatelessWidget {
  final Widget Function(BuildContext context, AuthScreenMetrics metrics)
  builder;

  const AuthScreenLayout({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Gradient adapts to the current theme.
    final gradientColors = isDark
        ? [AppColors.neutral900, AppColors.neutral800]
        : [AppColors.brandPrimary50, AppColors.brandPrimary100];

    return Container(
      // Fill the FULL screen including behind the AppBar so
      // extendBodyBehindAppBar:true screens show the gradient, not grey.
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        behavior: HitTestBehavior.opaque,
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              // Metrics derived from FULL-PAGE constraints — correct values.
              final m = AuthScreenMetrics.from(constraints);
              return SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  m.pageHorizontalPadding,
                  m.pageTopPadding,
                  m.pageHorizontalPadding,
                  m.pageBottomPadding,
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: math.max(
                      0.0,
                      constraints.maxHeight -
                          m.pageTopPadding -
                          m.pageBottomPadding,
                    ),
                  ),
                  child: Center(
                    child: SizedBox(
                      width: m.cardWidth,
                      child: _AuthCard(
                        metrics: m,
                        // Pass m to the content — no second LayoutBuilder needed.
                        child: builder(context, m),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// _AuthCard — private white card; respects ThemeMode.
// -----------------------------------------------------------------------------

class _AuthCard extends StatelessWidget {
  final AuthScreenMetrics metrics;
  final Widget child;

  const _AuthCard({required this.metrics, required this.child});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark
        ? DarkModeColors
              .surfacePrimary // neutral800 in dark
        : LightModeColors.surfacePrimary; // white in light

    return DecoratedBox(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(metrics.cardRadius),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: isDark ? 0.30 : 0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: metrics.cardHorizontalPadding,
          vertical: metrics.cardVerticalPadding,
        ),
        child: child,
      ),
    );
  }
}
