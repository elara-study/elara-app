import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_radius.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:elara/core/theme/app_spacing.dart';

///   full-width primary button with loading state
class AuthPrimaryButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;
  final bool isLoading;

  const AuthPrimaryButton({
    super.key,
    required this.label,
    this.icon,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: AppSpacing.spacingMd.h),
          backgroundColor: ButtonColors.primaryDefault,
          foregroundColor: ButtonColors.primaryText,
          disabledBackgroundColor: AppColors.brandPrimary200,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.radiusFull),
          ),
          elevation: 0,
        ),
        child: isLoading
            ? SizedBox(
                height: AppSpacing.spacingXl.h,
                width: AppSpacing.spacingXl.h,
                child: const CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    ButtonColors.primaryText,
                  ),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    label,
                    style: AppTypography.labelLarge(
                      color: ButtonColors.primaryText,
                    ),
                  ),
                  if (icon != null) ...[
                    SizedBox(width: AppSpacing.spacingSm.w),
                    Icon(icon, size: 16.sp),
                  ],
                ],
              ),
      ),
    );
  }
}
