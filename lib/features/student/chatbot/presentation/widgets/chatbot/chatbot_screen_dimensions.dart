import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Layout constants for [ChatbotScreen].
abstract final class ChatbotScreenDimensions {
  /// Glass header bar height (aligned with product chrome).
  static const double appBarHeight = 72;

  /// Drop shadow inside composer capsule (raised inset affordance).
  static const List<BoxShadow> composerInnerShadow = [
    BoxShadow(color: Color(0x04000000), offset: Offset(2, 2), blurRadius: 4),
  ];

  /// Drawer width — capped so content stays visible beside the sheet.
  static double drawerWidth(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    return math.min(320.0, w * 0.92);
  }
}
