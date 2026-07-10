import 'package:elara/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

/// A themed pull-to-refresh wrapper that matches the app's design system.
///
/// Wrap any scrollable child (SingleChildScrollView, ListView, etc.) to add
/// pull-to-refresh with a branded loading indicator.
class AppRefreshIndicator extends StatelessWidget {
  final Widget child;
  final Future<void> Function() onRefresh;
  final double displacement;
  final double edgeOffset;

  const AppRefreshIndicator({
    super.key,
    required this.child,
    required this.onRefresh,
    this.displacement = 40,
    this.edgeOffset = 0,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return RefreshIndicator(
      onRefresh: onRefresh,
      displacement: displacement,
      edgeOffset: edgeOffset,
      color: AppColors.brandPrimary500,
      backgroundColor: isDark ? AppColors.neutral800 : AppColors.white,
      strokeWidth: 2.5,
      child: child,
    );
  }
}
