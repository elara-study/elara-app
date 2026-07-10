import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_icon_sizes.dart';
import 'package:elara/core/theme/app_radius.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AuthSocialButton extends StatelessWidget {
  final String label;
  final String svgAsset;
  final VoidCallback onTap;
  final bool isLoading;

  const AuthSocialButton({
    super.key,
    required this.label,
    required this.svgAsset,
    required this.onTap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: isLoading ? null : onTap,
      style: OutlinedButton.styleFrom(
        backgroundColor: Colors.transparent,
        side: const BorderSide(color: ButtonColors.outlineBorder),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.spacingLg,
          vertical: AppSpacing.spacingSm,
        ),
        minimumSize: const Size(0, 40),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.radiusFull),
        ),
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isLoading)
              const SizedBox(
                width: AppIconSizes.iconSm,
                height: AppIconSizes.iconSm,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.neutral300),
                ),
              )
            else
              SvgPicture.asset(
                svgAsset,
                width: AppIconSizes.iconSm,
                height: AppIconSizes.iconSm,
              ),
            const SizedBox(width: AppSpacing.spacingSm),
            Text(
              label,
              maxLines: 1,
              style: AppTypography.labelRegular(
                color: isLoading ? ButtonColors.outlineText.withAlpha(127) : ButtonColors.outlineText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
