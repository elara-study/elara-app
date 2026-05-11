import 'dart:ui';

import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:flutter/material.dart';

class AppGlassHeader extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? subtitle;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;
  final List<Widget>? actions;
  final Widget? leading;
  final double height;
  final bool showDivider;
  final bool automaticallyImplyLeading;

  const AppGlassHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.titleStyle,
    this.subtitleStyle,
    this.actions,
    this.leading,
    this.height = kToolbarHeight,
    this.showDivider = true,
    this.automaticallyImplyLeading = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final glassBg = theme.brightness == Brightness.dark
        ? AppColors.neutral900Alpha70
        : AppColors.neutral50Alpha70;
    final dividerColor = theme.dividerTheme.color ?? cs.outlineVariant;
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: AppBar(
          // Figma: light rgba(248,250,252,0.7), dark rgba(15,23,42,0.7).
          backgroundColor: glassBg,
          surfaceTintColor:
              Colors.transparent, // Prevents Material 3 tinting overlay
          elevation: 0,
          // Ensures back arrow and icon buttons use the surface text colour
          // in both light and dark mode. Without this, Flutter may default to
          // white (invisible on a light scaffold background).
          iconTheme: IconThemeData(color: cs.onSurface),
          actionsIconTheme: IconThemeData(color: cs.onSurface),
          leading: leading,
          automaticallyImplyLeading: automaticallyImplyLeading,
          title: subtitle != null
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style:
                          titleStyle ??
                          AppTypography.h5(
                            font: "Comfortaa",
                            color: cs.onSurface,
                          ).copyWith(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      subtitle!,
                      style:
                          subtitleStyle ??
                          AppTypography.bodySmall(color: cs.onSurfaceVariant),
                    ),
                  ],
                )
              : Text(
                  title,
                  style:
                      titleStyle ??
                      AppTypography.h5(
                        font: "Comfortaa",
                        color: cs.onSurface,
                      ).copyWith(fontWeight: FontWeight.bold),
                ),
          actions: actions,
          centerTitle: false,
          bottom: showDivider
              ? PreferredSize(
                  preferredSize: const Size.fromHeight(1),
                  child: Divider(height: 1, thickness: 1, color: dividerColor),
                )
              : null,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height + (showDivider ? 1 : 0));
}
