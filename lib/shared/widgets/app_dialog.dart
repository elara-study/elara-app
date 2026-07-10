import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_icon_sizes.dart';
import 'package:elara/core/theme/app_radius.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class AppDialog extends StatelessWidget {
  final String? title;
  final Widget content;

  const AppDialog({super.key, this.title, required this.content});

  /// Displays the dialog using a custom slide-up and fade-in transition.
  static Future<T?> show<T>({
    required BuildContext context,
    required WidgetBuilder builder,
    bool barrierDismissible = true,
  }) {
    return showGeneralDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierLabel: 'App Dialog',
      barrierColor: AppColors.neutral900.withValues(alpha: 0.5),
      transitionDuration: const Duration(milliseconds: 280),
      pageBuilder: (ctx, _, __) => builder(ctx),
      transitionBuilder: (ctx, animation, _, child) {
        return FadeTransition(
          opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
          child: SlideTransition(
            position:
                Tween<Offset>(
                  begin: const Offset(0, 0.12),
                  end: Offset.zero,
                ).animate(
                  CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeOutCubic,
                  ),
                ),
            child: child,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: AppSpacing.spacing2xl.w),
          padding: EdgeInsets.all(AppSpacing.spacingLg.w),
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: BorderRadius.circular(AppRadius.radiusLg.r),
            boxShadow: [
              BoxShadow(
                color: cs.shadow.withValues(alpha: 0.18),
                blurRadius: 30,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (title != null) ...[
                // ── Header row ────────────────────────────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title!,
                      style: AppTypography.h5(
                        color: cs.onSurface,
                      ).copyWith(fontWeight: AppTypography.extraBold),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: SvgPicture.asset(
                        'assets/icons/clear_icon.svg',
                        width: AppIconSizes.icon2xs.w,
                        height: AppIconSizes.icon2xs.w,
                        colorFilter: ColorFilter.mode(
                          cs.onSurface,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppSpacing.spacingLg.h),
              ],

              // ── Content ───────────────────────────────────────────
              content,
            ],
          ),
        ),
      ),
    );
  }
}
