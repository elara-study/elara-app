import 'package:flutter/material.dart';

class AppTypography {
  AppTypography._();

  // Font family
  static const String nunito = 'Nunito';
  static const String comfortaa = 'Comfortaa';

  // Font weights
  static const FontWeight extraLight = FontWeight.w200;
  static const FontWeight light = FontWeight.w300;
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;
  static const FontWeight extraBold = FontWeight.w800;
  static const FontWeight black = FontWeight.w900;

  // Text styles for headings
  static TextStyle h1({Color? color, String? font}) => TextStyle(
    fontFamily: font ?? nunito,
    fontSize: 32,
    fontWeight: bold,
    height: 1.2,
    color: color,
  );

  static TextStyle h2({Color? color, String? font}) => TextStyle(
    fontFamily: font ?? nunito,
    fontSize: 28,
    fontWeight: bold,
    height: 1.2,
    color: color,
  );

  static TextStyle h3({Color? color, String? font}) => TextStyle(
    fontFamily: font ?? nunito,
    fontSize: 24,
    fontWeight: semiBold,
    height: 1.3,
    color: color,
  );

  static TextStyle h4({Color? color, String? font}) => TextStyle(
    fontFamily: font ?? nunito,
    fontSize: 20,
    fontWeight: semiBold,
    height: 1.3,
    color: color,
  );

  static TextStyle h5({Color? color, String? font}) => TextStyle(
    fontFamily: font ?? nunito,
    fontSize: 18,
    fontWeight: semiBold,
    height: 1.4,
    color: color,
  );

  static TextStyle h6({Color? color, String? font}) => TextStyle(
    fontFamily: font ?? nunito,
    fontSize: 16,
    fontWeight: semiBold,
    height: 1.4,
    color: color,
  );

  // Body text styles
  static TextStyle bodyLarge({Color? color, String? font}) => TextStyle(
    fontFamily: font ?? nunito,
    fontSize: 16,
    fontWeight: regular,
    height: 1.5,
    color: color,
  );

  static TextStyle bodyMedium({Color? color, String? font}) => TextStyle(
    fontFamily: font ?? nunito,
    fontSize: 14,
    fontWeight: regular,
    height: 1.5,
    color: color,
  );

  static TextStyle bodySmall({Color? color, String? font}) => TextStyle(
    fontFamily: font ?? nunito,
    fontSize: 12,
    fontWeight: regular,
    height: 1.5,
    color: color,
  );

  // Label text styles
  static TextStyle labelLarge({Color? color, String? font}) => TextStyle(
    fontFamily: font ?? nunito,
    fontSize: 16,
    fontWeight: semiBold,
    height: 1.4,
    color: color,
  );
  static TextStyle labelRegular({Color? color, String? font}) => TextStyle(
    fontFamily: font ?? nunito,
    fontSize: 14,
    fontWeight: semiBold,
    height: 1.4,
    color: color,
  );

  static TextStyle labelMedium({Color? color, String? font}) => TextStyle(
    fontFamily: font ?? nunito,
    fontSize: 12,
    fontWeight: medium,
    height: 1.4,
    color: color,
  );

  static TextStyle labelSmall({Color? color, String? font}) => TextStyle(
    fontFamily: font ?? nunito,
    fontSize: 12,
    fontWeight: semiBold,
    height: 1.4,
    color: color,
  );

  // Button text style
  static TextStyle button({Color? color, String? font}) => TextStyle(
    fontFamily: font ?? nunito,
    fontSize: 14,
    fontWeight: semiBold,
    height: 1.2,
    letterSpacing: 0.5,
    color: color,
  );

  // Caption text style
  static TextStyle caption({Color? color, String? font}) => TextStyle(
    fontFamily: font ?? nunito,
    fontSize: 12,
    fontWeight: regular,
    height: 1.4,
    color: color,
  );

  // Overline text style
  static TextStyle overline({Color? color, String? font}) => TextStyle(
    fontFamily: font ?? nunito,
    fontSize: 10,
    fontWeight: medium,
    height: 1.4,
    letterSpacing: 1.5,
    color: color,
  );
}
