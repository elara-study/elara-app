import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_radius.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeInOut,
        width: double.infinity,
        decoration: BoxDecoration(
          // Gradient: secondaryColor (lighter) → primaryColor (richer)
          gradient: LinearGradient(
            colors: [secondaryColor, primaryColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(AppRadius.radiusLg.r),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: primaryColor.withValues(alpha: 0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Decorative background circle — top-left
            Positioned(
              left: -40,
              child: Container(
                width: 128.w,
                height: 128.w,
                decoration: BoxDecoration(
                  color: AppColors.white.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
              ),
            ),

            // Content row
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
              child: Row(
                children: [
                  // Leading icon circle
                  Container(
                    width: 44.w,
                    height: 44.w,
                    decoration: BoxDecoration(
                      color: primaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, color: AppColors.neutral50, size: 20.sp),
                  ),

                  SizedBox(width: 12.w),

                  // Title + subtitle
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

                  // Glowing arrow button
                  Container(
                    width: 36.w,
                    height: 36.w,
                    decoration: BoxDecoration(
                      color: ButtonColors.secondaryReversedDefault,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: ButtonColors.secondaryReversedDefault
                              .withValues(alpha: 0.4),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
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
          ],
        ),
      ),
    );
  }
}
