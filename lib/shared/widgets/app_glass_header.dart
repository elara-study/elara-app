import 'dart:ui';
import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:flutter/material.dart';

class AppGlassHeader extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final double height;
  final bool showDivider;
  final bool automaticallyImplyLeading;

  const AppGlassHeader({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.height = kToolbarHeight,
    this.showDivider = true,
    this.automaticallyImplyLeading = false,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: AppBar(
          backgroundColor: LightModeColors.surfacePrimary.withValues(
            alpha: 0.85,
          ),
          surfaceTintColor:
              Colors.transparent, // Prevents Material 3 tinting overlay
          elevation: 0,
          leading: leading,
          automaticallyImplyLeading: automaticallyImplyLeading,
          title: Text(
            title,
            style: AppTypography.h5(
              font: "comfortaa",
              color: LightModeColors.textPrimary,
            ).copyWith(fontWeight: FontWeight.bold),
          ),
          actions: actions,
          centerTitle: false,
          bottom: showDivider
              ? PreferredSize(
                  preferredSize: const Size.fromHeight(1),
                  child: Divider(
                    height: 1,
                    thickness: 1,
                    color: AppColors.neutral200.withValues(alpha: 0.5),
                  ),
                )
              : null,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height + (showDivider ? 1 : 0));
}
