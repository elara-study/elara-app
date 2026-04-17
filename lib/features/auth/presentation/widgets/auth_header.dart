import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:elara/core/theme/app_spacing.dart';

/// Molecule: Elara logo + screen title + subtitle
class AuthHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const AuthHeader({super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SvgPicture.asset(
          'assets/images/logo.svg',
          width: 164.w,
          height: 96.83.w,
        ),
        SizedBox(height: AppSpacing.spacing4xl.h),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: AppTypography.h2(
                color: LightModeColors.textPrimary,
              ).copyWith(fontFamily: AppTypography.comfortaa),
            ),
            SizedBox(height: AppSpacing.spacingSm.h),
            Text(
              subtitle,
              style: AppTypography.bodyLarge(
                color: LightModeColors.textSecondary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
