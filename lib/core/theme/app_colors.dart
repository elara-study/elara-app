import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ============= NEUTRAL COLORS =============
  static const Color neutral50 = Color(0xFFF8FAFC);
  static const Color neutral100 = Color(0xFFF1F5F9);
  static const Color neutral200 = Color(0xFFE2E8F0);
  static const Color neutral300 = Color(0xFFCBD5E1);
  static const Color neutral400 = Color(0xFF94A3B8);
  static const Color neutral500 = Color(0xFF64748B);
  static const Color neutral600 = Color(0xFF475569);
  static const Color neutral700 = Color(0xFF334155);
  static const Color neutral800 = Color(0xFF1E293B);
  static const Color neutral900 = Color(0xFF0F172A);

  // Neutral with alpha
  static const Color neutral50Alpha70 = Color(
    0xB3F8FAFC,
  ); // rgba(248, 250, 252, 0.7)
  static const Color neutral900Alpha70 = Color(
    0xB30F172A,
  ); // rgba(15, 23, 42, 0.7)
  static const Color neutral800Alpha80 = Color(
    0xCC1E293B,
  ); // rgba(30, 41, 59, 0.8)

  // ============= BASE COLORS =============
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);

  // ============= BRAND PRIMARY COLORS =============
  static const Color brandPrimary50 = Color(0xFFEEF2F6);
  static const Color brandPrimary100 = Color(0xFFD4DDE8);
  static const Color brandPrimary200 = Color(0xFFB8C7D9);
  static const Color brandPrimary300 = Color(0xFF9BB1C9);
  static const Color brandPrimary400 = Color(0xFF7E9AB9);
  static const Color brandPrimary500 = Color(0xFF4D6A8A);
  static const Color brandPrimary600 = Color(0xFF3F5770);
  static const Color brandPrimary700 = Color(0xFF324557);
  static const Color brandPrimary800 = Color(0xFF24333F);
  static const Color brandPrimary900 = Color(0xFF172127);

  // Brand primary with alpha
  static const Color brandPrimary500Alpha10 = Color(
    0x1A4D6A8A,
  ); // rgba(77, 106, 138, 0.1)
  static const Color brandPrimary500Alpha20 = Color(
    0x334D6A8A,
  ); // rgba(77, 106, 138, 0.2)

  // ============= BRAND SECONDARY COLORS =============
  static const Color brandSecondary50 = Color(0xFFFEF3EF);
  static const Color brandSecondary100 = Color(0xFFFDE3D9);
  static const Color brandSecondary200 = Color(0xFFFBC7B3);
  static const Color brandSecondary300 = Color(0xFFF9AB8D);
  static const Color brandSecondary400 = Color(0xFFF78F67);
  static const Color brandSecondary500 = Color(0xFFE86B42);
  static const Color brandSecondary600 = Color(0xFFC65636);
  static const Color brandSecondary700 = Color(0xFFA4422A);
  static const Color brandSecondary800 = Color(0xFF822F1E);
  static const Color brandSecondary900 = Color(0xFF601C12);

  // Brand secondary with alpha
  static const Color brandSecondary500Alpha10 = Color(
    0x1AE86B42,
  ); // rgba(232, 107, 66, 0.1)
  static const Color brandSecondary500Alpha20 = Color(
    0x33E86B42,
  ); // rgba(232, 107, 66, 0.2)

  // ============= BRAND ACCENT COLORS =============
  static const Color brandAccent50 = Color(0xFFFFF8E6);
  static const Color brandAccent100 = Color(0xFFFFEFC0);
  static const Color brandAccent200 = Color(0xFFFFE599);
  static const Color brandAccent300 = Color(0xFFFFDB73);
  static const Color brandAccent400 = Color(0xFFFFD14D);
  static const Color brandAccent500 = Color(0xFFF5B800);
  static const Color brandAccent600 = Color(0xFFCC9900);
  static const Color brandAccent700 = Color(0xFFA37A00);
  static const Color brandAccent800 = Color(0xFF7A5C00);
  static const Color brandAccent900 = Color(0xFF523D00);

  // ============= SUCCESS COLORS =============
  static const Color success50 = Color(0xFFECFDF5);
  static const Color success100 = Color(0xFFD1FAE5);
  static const Color success200 = Color(0xFFA7F3D0);
  static const Color success300 = Color(0xFF6EE7B7);
  static const Color success400 = Color(0xFF34D399);
  static const Color success500 = Color(0xFF10B981);
  static const Color success600 = Color(0xFF059669);
  static const Color success700 = Color(0xFF047857);
  static const Color success800 = Color(0xFF065F46);
  static const Color success900 = Color(0xFF064E3B);

  // ============= WARNING COLORS =============
  static const Color warning50 = Color(0xFFFFFBEB);
  static const Color warning100 = Color(0xFFFEF3C7);
  static const Color warning200 = Color(0xFFFDE68A);
  static const Color warning300 = Color(0xFFFCD34D);
  static const Color warning400 = Color(0xFFFBBF24);
  static const Color warning500 = Color(0xFFF59E0B);
  static const Color warning600 = Color(0xFFD97706);
  static const Color warning700 = Color(0xFFB45309);
  static const Color warning800 = Color(0xFF92400E);
  static const Color warning900 = Color(0xFF78350F);

  // ============= ERROR COLORS =============
  static const Color error50 = Color(0xFFFEF2F2);
  static const Color error100 = Color(0xFFFEE2E2);
  static const Color error200 = Color(0xFFFECACA);
  static const Color error300 = Color(0xFFFCA5A5);
  static const Color error400 = Color(0xFFF87171);
  static const Color error500 = Color(0xFFEF4444);
  static const Color error600 = Color(0xFFDC2626);
  static const Color error700 = Color(0xFFB91C1C);
  static const Color error800 = Color(0xFF991B1B);
  static const Color error900 = Color(0xFF7F1D1D);

  // ============= INFO COLORS =============
  static const Color info50 = Color(0xFFEFF6FF);
  static const Color info100 = Color(0xFFDBEAFE);
  static const Color info200 = Color(0xFFBFDBFE);
  static const Color info300 = Color(0xFF93C5FD);
  static const Color info400 = Color(0xFF60A5FA);
  static const Color info500 = Color(0xFF3B82F6);
  static const Color info600 = Color(0xFF2563EB);
  static const Color info700 = Color(0xFF1D4ED8);
  static const Color info800 = Color(0xFF1E40AF);
  static const Color info900 = Color(0xFF1E3A8A);
}

/// Light mode semantic colors
class LightModeColors {
  LightModeColors._();

  // Surface colors
  static const Color surfaceApp = AppColors.neutral50;
  static const Color surfacePrimary = AppColors.white;
  static const Color surfaceSecondary = AppColors.neutral100;
  static const Color surfaceElevated = AppColors.white;
  static const Color surfaceInverted = AppColors.neutral900;
  static const Color surfaceAppAlpha70 = AppColors.neutral50Alpha70;
  static const Color surfacePrimaryAlpha80 = Color(
    0xCCFFFFFF,
  ); // rgba(255, 255, 255, 0.8)

  // Text colors
  static const Color textPrimary = AppColors.neutral900;
  static const Color textSecondary = AppColors.neutral600;
  static const Color textDisabled = AppColors.neutral400;
  static const Color textPrimaryInverse = AppColors.neutral50;
  static const Color textSecondaryInverse = AppColors.neutral200;

  // Border colors
  static const Color borderDefault = AppColors.neutral200;
  static const Color borderDivider = AppColors.neutral200;
  static const Color borderFocused = AppColors.brandPrimary500;
  static const Color borderDisabled = AppColors.neutral100;
  static const Color borderAccentOutline = AppColors.brandSecondary500;
}

/// Dark mode semantic colors
class DarkModeColors {
  DarkModeColors._();

  // Surface colors
  static const Color surfaceApp = AppColors.neutral900;
  static const Color surfacePrimary = AppColors.neutral800;
  static const Color surfaceSecondary = AppColors.neutral700;
  static const Color surfaceElevated = AppColors.neutral600;
  static const Color surfaceInverted = AppColors.neutral50;
  static const Color surfaceAppAlpha70 = AppColors.neutral900Alpha70;
  static const Color surfacePrimaryAlpha80 = AppColors.neutral800Alpha80;

  // Text colors
  static const Color textPrimary = AppColors.neutral50;
  static const Color textSecondary = AppColors.neutral300;
  static const Color textDisabled = AppColors.neutral500;
  static const Color textPrimaryInverse = AppColors.neutral900;
  static const Color textSecondaryInverse = AppColors.neutral700;

  // Border colors
  static const Color borderDefault = AppColors.neutral700;
  static const Color borderDivider = AppColors.neutral700;
  static const Color borderFocused = AppColors.brandPrimary400;
  static const Color borderDisabled = AppColors.neutral800;
  static const Color borderAccentOutline = AppColors.brandSecondary400;
}

/// Button component colors
class ButtonColors {
  ButtonColors._();

  // Primary button
  static const Color primaryDefault = AppColors.brandPrimary500;
  static const Color primaryHover = AppColors.brandPrimary600;
  static const Color primaryPressed = AppColors.brandPrimary700;
  static const Color primaryDisabled = AppColors.brandPrimary200;
  static const Color primaryText = AppColors.white;
  static const Color primaryTextDisabled = AppColors.neutral500;

  // Secondary button
  static const Color secondaryDefault = AppColors.brandSecondary500;
  static const Color secondaryHover = AppColors.brandSecondary600;
  static const Color secondaryPressed = AppColors.brandSecondary700;
  static const Color secondaryDisabled = AppColors.brandSecondary200;
  static const Color secondaryText = AppColors.white;
  static const Color secondaryTextDisabled = AppColors.neutral500;

  // Ghost button
  static const Color ghostText = AppColors.brandPrimary500;
  static const Color ghostTextDisabled = AppColors.neutral400;
  static const Color ghostHover = AppColors.brandPrimary500Alpha10;
  static const Color ghostPressed = AppColors.brandPrimary500Alpha20;

  // Outline button
  static const Color outlineText = AppColors.brandPrimary500;
  static const Color outlineTextDisabled = AppColors.neutral400;
  static const Color outlineHover = AppColors.brandPrimary500Alpha10;
  static const Color outlinePressed = AppColors.brandPrimary500Alpha20;
  static const Color outlineBorder = AppColors.brandPrimary500;
  static const Color outlineBorderDisabled = AppColors.neutral300;

  // Primary Reversed button
  static const Color primaryReversedDefault = AppColors.white;
  static const Color primaryReversedHover = AppColors.brandPrimary50;
  static const Color primaryReversedPressed = AppColors.brandPrimary100;
  static const Color primaryReversedDisabled = AppColors.brandPrimary200;
  static const Color primaryReversedText = AppColors.brandPrimary500;
  static const Color primaryReversedTextDisabled = AppColors.neutral500;

  // Secondary Reversed button
  static const Color secondaryReversedDefault = AppColors.white;
  static const Color secondaryReversedHover = AppColors.brandSecondary50;
  static const Color secondaryReversedPressed = AppColors.brandSecondary100;
  static const Color secondaryReversedDisabled = AppColors.brandSecondary200;
  static const Color secondaryReversedText = AppColors.brandSecondary500;
  static const Color secondaryReversedTextDisabled = AppColors.neutral500;
}
