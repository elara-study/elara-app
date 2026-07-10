import 'dart:ui' show ImageFilter;

import 'package:elara/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

/// App-wide shadow and blur tokens.
///
/// **Elevation** — theme-aware drop shadow (light: black ~8%, dark: white 6%).
/// **Glow** — soft lift using #F8FAFC at 50% (see [glow]).
/// **Background blur** — use [backgroundBlur] with [BackdropFilter], not
/// [BoxDecoration.boxShadow].
class AppShadows {
  AppShadows._();

  /// Light mode: offset (0, 4), blur 20, #000000 at ~8%.
  /// Same blur and offset as many design specs; for **15%** opacity black see
  /// [dropShadow].
  static const List<BoxShadow> elevationLight = [
    BoxShadow(color: Color(0x14000000), offset: Offset(0, 4), blurRadius: 20),
  ];

  /// Black drop shadow — offset (0, 4), blur 20, spread 0, **15%** opacity.
  static const List<BoxShadow> dropShadow = [
    BoxShadow(color: Color(0x26000000), offset: Offset(0, 4), blurRadius: 20),
  ];

  /// Dark mode: offset (0, 4), blur 20, #FFFFFF at 6%.
  static const List<BoxShadow> elevationDark = [
    BoxShadow(color: Color(0x0FFFFFFF), offset: Offset(0, 4), blurRadius: 20),
  ];

  /// Elevation shadow for the current [Brightness].
  static List<BoxShadow> elevation(Brightness brightness) =>
      brightness == Brightness.dark ? elevationDark : elevationLight;

  /// Tint for [Material] / [Card] shadows — same channel as [elevation] but
  /// [Card] uses [Material] elevation, not [BoxDecoration.boxShadow].
  static Color materialElevationShadowColor(Brightness brightness) =>
      elevation(brightness).first.color;

  /// [CardThemeData.elevation] tuned so the default [Card] shadow reads close to
  /// our design tokens (y≈4, blur≈20); exact blur is controlled by Material.
  static const double cardMaterialElevation = 4;

  /// Glow: offset (0, 4), blur 24, #F8FAFC at 50%.
  static const List<BoxShadow> glow = [
    BoxShadow(color: Color(0x80F8FAFC), offset: Offset(0, 4), blurRadius: 24),
  ];

  /// Brand-primary pill (e.g. segmented tab indicator). Not the neutral [glow].
  static List<BoxShadow> brandPrimaryPillGlow() => [
    BoxShadow(
      color: AppColors.brandPrimary500.withValues(alpha: 0.35),
      blurRadius: 12,
      offset: const Offset(0, 4),
    ),
  ];

  /// Sigma for frosted background blur (e.g. with [BackdropFilter]).
  static const double backgroundBlurSigma = 24;

  /// [ImageFilter] for background blur; sigma [backgroundBlurSigma].
  static ImageFilter get backgroundBlur => ImageFilter.blur(
    sigmaX: backgroundBlurSigma,
    sigmaY: backgroundBlurSigma,
  );
}
