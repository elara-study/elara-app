import 'package:elara/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

/// Shared [LinearGradient]s — keep brand headers consistent app-wide.
class AppGradients {
  AppGradients._();

  static const LinearGradient brandPrimaryHorizontal = LinearGradient(
    colors: [AppColors.brandPrimary400, AppColors.brandPrimary500],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient brandPrimaryDiagonal = LinearGradient(
    colors: [AppColors.brandPrimary400, AppColors.brandPrimary500],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
