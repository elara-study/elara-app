import 'dart:ui';

import 'package:elara/core/theme/app_icon_sizes.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
    this.automaticallyImplyLeading = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final scaffoldBg = theme.scaffoldBackgroundColor;
    final dividerColor = theme.dividerTheme.color ?? cs.outlineVariant;
    final ModalRoute<dynamic>? parentRoute = ModalRoute.of(context);
    final bool canPop = parentRoute?.canPop ?? false;

    Widget? actualLeading = leading;
    if (actualLeading == null && automaticallyImplyLeading && canPop) {
      actualLeading = Center(
        child: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: SvgPicture.asset(
            'assets/icons/back_arrow_icon.svg',
            height: AppIconSizes.iconXs.h,
            width: AppIconSizes.iconXs.w,
            color: cs.onSurface,
          ),
        ),
      );
    } else if (actualLeading != null) {
      actualLeading = Center(child: actualLeading);
    }

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: AppBar(
          // backgroundColor: LightModeColors.surfacePrimary.withValues(
          //   alpha: 0.85,
          // ),
          // surfaceTintColor:
          //     Colors.transparent, // Prevents Material 3 tinting overlay
          backgroundColor: scaffoldBg,
          surfaceTintColor:
              Colors.transparent, // Prevents Material 3 tinting overlay
          elevation: 0,
          // Ensures back arrow and icon buttons use the surface text colour
          // in both light and dark mode. Without this, Flutter may default to
          // white (invisible on a light scaffold background).
          iconTheme: IconThemeData(color: cs.onSurface),
          actionsIconTheme: IconThemeData(color: cs.onSurface),
          leading: actualLeading,
          leadingWidth: AppSpacing.spacing6xl.w,
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
