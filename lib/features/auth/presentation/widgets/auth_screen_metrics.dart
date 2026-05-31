import 'dart:math' as math;

import 'package:flutter/widgets.dart';

/// Single responsive metrics object shared by every auth screen.

class AuthScreenMetrics {
  // page
  final double pageHorizontalPadding;
  final double pageTopPadding;
  final double pageBottomPadding;

  // card
  final double cardWidth;
  final double cardHorizontalPadding;
  final double cardVerticalPadding;
  final double cardRadius;

  //   spacing
  final double sectionGap;
  final double fieldGap;
  final double socialGap;

  //   role cards (only used by sign-up role screen)
  final double roleGap;
  final double roleCardHeight;
  final double roleCardContentPadding;
  final double roleIconSize;
  final double roleArrowSize;

  //   flags
  final bool shouldStackSocialButtons;
  final bool isCompact;

  const AuthScreenMetrics({
    required this.pageHorizontalPadding,
    required this.pageTopPadding,
    required this.pageBottomPadding,
    required this.cardWidth,
    required this.cardHorizontalPadding,
    required this.cardVerticalPadding,
    required this.cardRadius,
    required this.sectionGap,
    required this.fieldGap,
    required this.socialGap,
    required this.roleGap,
    required this.roleCardHeight,
    required this.roleCardContentPadding,
    required this.roleIconSize,
    required this.roleArrowSize,
    required this.shouldStackSocialButtons,
    required this.isCompact,
  });

  factory AuthScreenMetrics.from(BoxConstraints constraints) {
    final w = constraints.maxWidth;
    final h = constraints.maxHeight;
    final isCompact = w < 360 || h < 760;
    final isVeryNarrow = w < 330;
    final isShort = h < 700;

    final pageH = (w * 0.0615).clamp(12.0, 32.0);
    final pageT = (h * (isShort ? 0.028 : 0.064)).clamp(16.0, 54.0);
    final pageB = (h * 0.025).clamp(12.0, 24.0);

    final available = math.max(w - pageH * 2, 0.0);

    final cardWidth = math.min(available, 342.0 * (w / 390.0));

    final wRatio = (cardWidth / 342.0).clamp(0.72, 1.17);
    final hRatio = (h / 844.0).clamp(0.76, 1.0);
    final density = math.min(wRatio, hRatio);

    final cardHPad = (20.0 * wRatio).clamp(12.0, 24.0);
    final contentWidth = cardWidth - cardHPad * 2;

    return AuthScreenMetrics(
      pageHorizontalPadding: pageH,
      pageTopPadding: pageT,
      pageBottomPadding: pageB,
      cardWidth: cardWidth,
      cardHorizontalPadding: cardHPad,
      cardVerticalPadding: (32.0 * density).clamp(16.0, 32.0),
      cardRadius: (32.0 * wRatio).clamp(24.0, 32.0),
      sectionGap: (24.0 * density).clamp(10.0, 24.0),
      fieldGap: (8.0 * density).clamp(6.0, 8.0),
      socialGap: (16.0 * wRatio).clamp(8.0, 16.0),
      roleGap: (16.0 * density).clamp(8.0, 16.0),
      roleCardHeight: (76.0 * density).clamp(60.0, 80.0),
      roleCardContentPadding: (16.0 * wRatio).clamp(10.0, 16.0),
      roleIconSize: (44.0 * wRatio).clamp(36.0, 44.0),
      roleArrowSize: (36.0 * wRatio).clamp(30.0, 36.0),
      shouldStackSocialButtons: isVeryNarrow || contentWidth < 274,
      isCompact: isCompact,
    );
  }
}
