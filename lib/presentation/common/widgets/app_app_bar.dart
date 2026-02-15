import 'dart:ui';

import 'package:elara/config/routes.dart';
import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:flutter/material.dart';

/// App bar matching Figma: frosted glass, backdrop blur 24px, bottom border.
///
/// **Variants:**
/// - [AppAppBar.mainTab] – Main tab screens (Learn, My Classes, Profile), no back
/// - [AppAppBar.detail] – Detail screens with back button
/// - [AppAppBar.withTabs] – Detail with TabBar (e.g. Class detail)
/// - [AppAppBar.minimal] – Title only
/// - [AppAppBar] – Full control
///
/// **Action helpers:** [notificationAction], [switchRoleAction], [addAction],
/// [settingsAction], [mainTabActions]
class AppAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool automaticallyImplyLeading;
  final PreferredSizeWidget? bottom;

  const AppAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.bottom,
  });

  /// Main tab screens (Learn, My Classes, Profile): no back button.
  const AppAppBar.mainTab({super.key, required this.title, this.actions})
    : leading = null,
      automaticallyImplyLeading = false,
      bottom = null;

  /// Detail/drill-down screens: shows back button when navigator can pop.
  const AppAppBar.detail({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.bottom,
  }) : automaticallyImplyLeading = true;

  /// Title only, no leading or actions.
  const AppAppBar.minimal({super.key, required this.title})
    : actions = null,
      leading = null,
      automaticallyImplyLeading = false,
      bottom = null;

  /// Detail screen with TabBar (e.g. class detail with Students/Quizzes tabs).
  const AppAppBar.withTabs({
    super.key,
    required this.title,
    required this.bottom,
    this.actions,
  }) : leading = null,
       automaticallyImplyLeading = true;

  /// Build common action buttons for easy reuse.
  static List<Widget> switchRoleAction(BuildContext context) => [
    IconButton(
      icon: const Icon(Icons.swap_horiz),
      tooltip: 'Switch role',
      onPressed: () =>
          Navigator.of(context).pushReplacementNamed(AppRoutes.roleSelector),
    ),
  ];

  static List<Widget> addAction({VoidCallback? onPressed}) => [
    IconButton(icon: const Icon(Icons.add), onPressed: onPressed ?? () {}),
  ];

  static List<Widget> settingsAction({VoidCallback? onPressed}) => [
    IconButton(icon: const Icon(Icons.settings), onPressed: onPressed ?? () {}),
  ];

  /// Main tab with notifications + switch role (Teacher/Student).
  static List<Widget> mainTabActions(
    BuildContext context, {
    VoidCallback? onNotificationPressed,
  }) => [...switchRoleAction(context)];

  @override
  Size get preferredSize {
    final bottomHeight = bottom?.preferredSize.height ?? 0.0;
    // Include top safe area (SafeArea adds padding in toolbar) to prevent overflow
    const topSafeArea = 47.0; // typical notch height
    return Size.fromHeight(
      topSafeArea + kToolbarHeight + bottomHeight + 1,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark
        ? AppColors.neutral900Alpha70
        : AppColors.neutral50Alpha70;
    final borderColor = isDark ? AppColors.neutral700 : AppColors.neutral200;
    final fgColor = isDark ? AppColors.neutral50 : AppColors.neutral900;

    final toolbar = ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
        child: Container(
          decoration: BoxDecoration(
            color: bgColor,
            border: Border(
              bottom: bottom == null
                  ? BorderSide(color: borderColor, width: 1)
                  : BorderSide.none,
            ),
          ),
          child: Theme(
            data: Theme.of(context).copyWith(
              iconTheme: IconThemeData(color: fgColor),
              iconButtonTheme: IconButtonThemeData(
                style: IconButton.styleFrom(foregroundColor: fgColor),
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: SizedBox(
                height: kToolbarHeight,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Text(
                      title,
                      style: AppTypography.h6(color: fgColor),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Positioned(
                      left: 0,
                      top: 0,
                      bottom: 0,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (leading != null)
                            leading!
                          else if (automaticallyImplyLeading &&
                              Navigator.of(context).canPop())
                            IconButton(
                              icon: const Icon(Icons.arrow_back),
                              onPressed: () => Navigator.of(context).pop(),
                              color: fgColor,
                            )
                          else
                            const SizedBox(width: 48),
                        ],
                      ),
                    ),
                    Positioned(
                      right: 0,
                      top: 0,
                      bottom: 0,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: actions ?? [],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );

    if (bottom != null) {
      final bottomHeight = bottom!.preferredSize.height;
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          toolbar,
          SizedBox(height: bottomHeight, child: bottom!),
          Container(height: 1, color: borderColor),
        ],
      );
    }
    return toolbar;
  }
}
