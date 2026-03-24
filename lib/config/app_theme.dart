import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_radius.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:flutter/material.dart';

/// App theme configuration
class AppTheme {
  AppTheme._();

  /// Light theme
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,

    // Color scheme
    colorScheme: const ColorScheme.light(
      primary: AppColors.brandPrimary500,
      secondary: AppColors.brandSecondary500,
      tertiary: AppColors.brandAccent500,
      error: AppColors.error500,
      surface: LightModeColors.surfacePrimary,
      onPrimary: ButtonColors.primaryText,
      onSecondary: ButtonColors.secondaryText,
      onSurface: LightModeColors.textPrimary,
      onError: AppColors.white,
      outline: LightModeColors.borderDefault,
    ),

    scaffoldBackgroundColor: LightModeColors.surfaceApp,

    // AppBar theme
    appBarTheme: AppBarTheme(
      elevation: 0,
      centerTitle: true,
      backgroundColor: AppColors.brandPrimary500,
      foregroundColor: AppColors.white,
      titleTextStyle: AppTypography.h6(color: AppColors.white),
      iconTheme: const IconThemeData(color: AppColors.white),
    ),

    // Card theme
    cardTheme: CardThemeData(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.radiusMd),
      ),
      color: LightModeColors.surfaceElevated,
    ),

    // Elevated button theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: ButtonColors.primaryDefault,
        foregroundColor: ButtonColors.primaryText,
        disabledBackgroundColor: ButtonColors.primaryDisabled,
        disabledForegroundColor: ButtonColors.primaryTextDisabled,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.spacing2xl,
          vertical: AppSpacing.spacingLg,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.radiusSm),
        ),
        textStyle: AppTypography.button(),
        elevation: 0,
      ),
    ),

    // Outlined button theme
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: ButtonColors.outlineText,
        disabledForegroundColor: ButtonColors.outlineTextDisabled,
        side: const BorderSide(color: ButtonColors.outlineBorder, width: 1),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.spacing2xl,
          vertical: AppSpacing.spacingLg,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.radiusSm),
        ),
        textStyle: AppTypography.button(),
      ),
    ),

    // Text button theme
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: ButtonColors.ghostText,
        disabledForegroundColor: ButtonColors.ghostTextDisabled,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.spacing2xl,
          vertical: AppSpacing.spacingLg,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.radiusSm),
        ),
        textStyle: AppTypography.button(),
      ),
    ),

    // Input decoration theme
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: LightModeColors.surfacePrimary,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.radiusSm),
        borderSide: const BorderSide(color: LightModeColors.borderDefault),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.radiusSm),
        borderSide: const BorderSide(color: LightModeColors.borderDefault),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.radiusSm),
        borderSide: const BorderSide(
          color: LightModeColors.borderFocused,
          width: 2,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.radiusSm),
        borderSide: const BorderSide(color: AppColors.error500),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.radiusSm),
        borderSide: const BorderSide(color: LightModeColors.borderDisabled),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.spacingLg,
        vertical: AppSpacing.spacingLg,
      ),
      hintStyle: AppTypography.bodyMedium(color: LightModeColors.textSecondary),
      labelStyle: AppTypography.bodyMedium(
        color: LightModeColors.textSecondary,
      ),
    ),

    // Divider theme
    dividerTheme: const DividerThemeData(
      color: LightModeColors.borderDivider,
      thickness: 1,
      space: 1,
    ),

    // Text theme
    textTheme: TextTheme(
      displayLarge: AppTypography.h1(color: LightModeColors.textPrimary),
      displayMedium: AppTypography.h2(color: LightModeColors.textPrimary),
      displaySmall: AppTypography.h3(color: LightModeColors.textPrimary),
      headlineLarge: AppTypography.h4(color: LightModeColors.textPrimary),
      headlineMedium: AppTypography.h5(color: LightModeColors.textPrimary),
      headlineSmall: AppTypography.h6(color: LightModeColors.textPrimary),
      bodyLarge: AppTypography.bodyLarge(color: LightModeColors.textPrimary),
      bodyMedium: AppTypography.bodyMedium(color: LightModeColors.textPrimary),
      bodySmall: AppTypography.bodySmall(color: LightModeColors.textSecondary),
      labelLarge: AppTypography.labelLarge(color: LightModeColors.textPrimary),
      labelMedium: AppTypography.labelMedium(
        color: LightModeColors.textSecondary,
      ),
      labelSmall: AppTypography.labelSmall(
        color: LightModeColors.textSecondary,
      ),
    ),

    // Icon theme
    iconTheme: const IconThemeData(
      color: LightModeColors.textPrimary,
      size: 24,
    ),

    // Bottom navigation bar theme
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: LightModeColors.surfacePrimary,
      selectedItemColor: AppColors.brandPrimary500,
      unselectedItemColor: LightModeColors.textSecondary,
      elevation: 8,
      type: BottomNavigationBarType.fixed,
    ),
  );

  /// Dark theme
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,

    // Color scheme
    colorScheme: const ColorScheme.dark(
      primary: AppColors.brandPrimary500,
      secondary: AppColors.brandSecondary500,
      tertiary: AppColors.brandAccent500,
      error: AppColors.error500,
      surface: DarkModeColors.surfacePrimary,
      onPrimary: ButtonColors.primaryText,
      onSecondary: ButtonColors.secondaryText,
      onSurface: DarkModeColors.textPrimary,
      onError: AppColors.white,
      outline: DarkModeColors.borderDefault,
    ),

    scaffoldBackgroundColor: DarkModeColors.surfaceApp,

    // AppBar theme
    appBarTheme: AppBarTheme(
      elevation: 0,
      centerTitle: true,
      backgroundColor: DarkModeColors.surfacePrimary,
      foregroundColor: DarkModeColors.textPrimary,
      titleTextStyle: AppTypography.h6(color: DarkModeColors.textPrimary),
      iconTheme: const IconThemeData(color: DarkModeColors.textPrimary),
    ),

    // Card theme
    cardTheme: CardThemeData(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.radiusMd),
      ),
      color: DarkModeColors.surfaceElevated,
    ),

    // Elevated button theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: ButtonColors.primaryDefault,
        foregroundColor: ButtonColors.primaryText,
        disabledBackgroundColor: ButtonColors.primaryDisabled,
        disabledForegroundColor: ButtonColors.primaryTextDisabled,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.spacing2xl,
          vertical: AppSpacing.spacingLg,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.radiusSm),
        ),
        textStyle: AppTypography.button(),
        elevation: 0,
      ),
    ),

    // Outlined button theme
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: ButtonColors.outlineText,
        disabledForegroundColor: ButtonColors.outlineTextDisabled,
        side: const BorderSide(color: ButtonColors.outlineBorder, width: 1),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.spacing2xl,
          vertical: AppSpacing.spacingLg,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.radiusSm),
        ),
        textStyle: AppTypography.button(),
      ),
    ),

    // Text button theme
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: ButtonColors.ghostText,
        disabledForegroundColor: ButtonColors.ghostTextDisabled,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.spacing2xl,
          vertical: AppSpacing.spacingLg,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.radiusSm),
        ),
        textStyle: AppTypography.button(),
      ),
    ),

    // Input decoration theme
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: DarkModeColors.surfacePrimary,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.radiusSm),
        borderSide: const BorderSide(color: DarkModeColors.borderDefault),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.radiusSm),
        borderSide: const BorderSide(color: DarkModeColors.borderDefault),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.radiusSm),
        borderSide: const BorderSide(
          color: DarkModeColors.borderFocused,
          width: 2,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.radiusSm),
        borderSide: const BorderSide(color: AppColors.error500),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.radiusSm),
        borderSide: const BorderSide(color: DarkModeColors.borderDisabled),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.spacingLg,
        vertical: AppSpacing.spacingLg,
      ),
      hintStyle: AppTypography.bodyMedium(color: DarkModeColors.textSecondary),
      labelStyle: AppTypography.bodyMedium(color: DarkModeColors.textSecondary),
    ),

    // Divider theme
    dividerTheme: const DividerThemeData(
      color: DarkModeColors.borderDivider,
      thickness: 1,
      space: 1,
    ),

    // Text theme
    textTheme: TextTheme(
      displayLarge: AppTypography.h1(color: DarkModeColors.textPrimary),
      displayMedium: AppTypography.h2(color: DarkModeColors.textPrimary),
      displaySmall: AppTypography.h3(color: DarkModeColors.textPrimary),
      headlineLarge: AppTypography.h4(color: DarkModeColors.textPrimary),
      headlineMedium: AppTypography.h5(color: DarkModeColors.textPrimary),
      headlineSmall: AppTypography.h6(color: DarkModeColors.textPrimary),
      bodyLarge: AppTypography.bodyLarge(color: DarkModeColors.textPrimary),
      bodyMedium: AppTypography.bodyMedium(color: DarkModeColors.textPrimary),
      bodySmall: AppTypography.bodySmall(color: DarkModeColors.textSecondary),
      labelLarge: AppTypography.labelLarge(color: DarkModeColors.textPrimary),
      labelMedium: AppTypography.labelMedium(
        color: DarkModeColors.textSecondary,
      ),
      labelSmall: AppTypography.labelSmall(color: DarkModeColors.textSecondary),
    ),

    // Icon theme
    iconTheme: const IconThemeData(color: DarkModeColors.textPrimary, size: 24),

    // Bottom navigation bar theme
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: DarkModeColors.surfacePrimary,
      selectedItemColor: AppColors.brandPrimary500,
      unselectedItemColor: DarkModeColors.textSecondary,
      elevation: 8,
      type: BottomNavigationBarType.fixed,
    ),
  );
}
