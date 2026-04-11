import 'package:flutter/material.dart';

/// Breakpoints
const double _kMobileBreakpoint = 600;
const double _kTabletBreakpoint = 1024;

extension ResponsiveContext on BuildContext {
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;

  bool get isMobile => screenWidth < _kMobileBreakpoint;
  bool get isTablet =>
      screenWidth >= _kMobileBreakpoint && screenWidth < _kTabletBreakpoint;
  bool get isDesktop => screenWidth >= _kTabletBreakpoint;

  ResponsiveValue get responsive => ResponsiveValue(this);
}

class ResponsiveValue {
  final BuildContext context;
  const ResponsiveValue(this.context);

  T value<T>({required T mobile, T? tablet, T? desktop}) {
    if (context.isDesktop && desktop != null) return desktop;
    if (context.isTablet && tablet != null) return tablet;
    return mobile;
  }
}
