import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_radius.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:elara/shared/widgets/gradient_glow_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:elara/core/theme/app_spacing.dart';

List<BoxShadow> _selectionGlow(Color primaryColor) => [
  BoxShadow(
    color: primaryColor.withValues(alpha: 0.4),
    blurRadius: 12,
    offset: const Offset(0, 4),
  ),
];

List<BoxShadow> _arrowChipGlow(Color surface) => [
  BoxShadow(
    color: surface.withValues(alpha: 0.4),
    blurRadius: 20,
    spreadRadius: 5,
  ),
];

/// Generic action card molecule.

class AppActionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  /// The card's solid base colour (also the icon circle background).
  final Color primaryColor;

  /// The lighter gradient start colour (top-left corner).
  final Color secondaryColor;

  final VoidCallback onTap;
  final bool isSelected;

  const AppActionCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.primaryColor,
    required this.secondaryColor,
    required this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(AppRadius.radiusLg.r);
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeInOut,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [secondaryColor, primaryColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: radius,
          boxShadow: isSelected ? _selectionGlow(primaryColor) : const [],
        ),
        child: GradientGlowClipStack(
          borderRadius: radius,
          glowTint: GradientGlowTints.whiteVeil,
          glowOrbs: GradientGlowOrbs.actionListRow,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.spacingLg.w,
              vertical: AppSpacing.spacing2xl.h,
            ),
            child: Row(
              children: [
                Container(
                  width: 44.w,
                  height: 44.w,
                  decoration: BoxDecoration(
                    color: primaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: SvgPicture.asset(
                    'assets/icons/people_outline.svg',
                    width: AppSpacing.spacingXl.w,
                    height: AppSpacing.spacingXl.w,
                    fit: BoxFit.scaleDown,
                    colorFilter: const ColorFilter.mode(
                      AppColors.neutral50,
                      BlendMode.srcIn,
                    ),
                  ),
                ),

                SizedBox(width: AppSpacing.spacingMd.w),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppTypography.labelLarge(
                          color: AppColors.neutral50,
                        ),
                      ),
                      Text(
                        subtitle,
                        style: AppTypography.bodySmall(
                          color: AppColors.neutral200,
                        ),
                      ),
                    ],
                  ),
                ),

                Container(
                  width: AppSpacing.spacing4xl.w,
                  height: AppSpacing.spacing4xl.w,
                  decoration: BoxDecoration(
                    color: ButtonColors.secondaryReversedDefault,
                    shape: BoxShape.circle,
                    boxShadow: _arrowChipGlow(
                      ButtonColors.secondaryReversedDefault,
                    ),
                  ),
                  child: Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: primaryColor,
                    size: 16.sp,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
