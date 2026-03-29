import 'package:elara/core/enums/user_role.dart';
import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_radius.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Molecule: role selector card shown on Sign Up - Role screen.
/// Color-coded per role: Student=blue, Teacher=orange, Parent=green.
class RoleCard extends StatelessWidget {
  final UserRole role;
  final bool isSelected;
  final VoidCallback onTap;

  const RoleCard({
    super.key,
    required this.role,
    required this.isSelected,
    required this.onTap,
  });

  Color get _cardColor {
    switch (role) {
      case UserRole.student:
        return AppColors.brandPrimary500;
      case UserRole.teacher:
        return AppColors.brandSecondary500;
      case UserRole.parent:
        return AppColors.success500;
    }
  }

  Color get _cardColorgradient {
    switch (role) {
      case UserRole.student:
        return AppColors.brandPrimary400;
      case UserRole.teacher:
        return AppColors.brandSecondary400;
      case UserRole.parent:
        return AppColors.success400;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeInOut,
        width: double.infinity,
        decoration: BoxDecoration(
          color: _cardColor,
          gradient: LinearGradient(
            colors: [_cardColorgradient, _cardColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(AppRadius.radiusLg.r),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: _cardColor.withValues(alpha: 0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
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
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
              child: Row(
                children: [
                  Container(
                    width: 44.w,
                    height: 44.w,
                    decoration: BoxDecoration(
                      color: _cardColor,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.people_outline,
                      color: AppColors.neutral50,
                      size: 20.sp,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          role.displayName,
                          style: AppTypography.labelLarge(
                            color: AppColors.neutral50,
                          ),
                        ),
                        // SizedBox(height: 2.h),
                        Text(
                          role.subtitle,
                          style: AppTypography.bodySmall(
                            color: AppColors.neutral200,
                          ),
                        ),
                      ],
                    ),
                  ),
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
                          // offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: _cardColor,
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
