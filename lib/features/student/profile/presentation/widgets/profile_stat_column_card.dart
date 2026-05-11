import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_radius.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:elara/shared/widgets/gradient_glow_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProfileStatColumnCard extends StatelessWidget {
  const ProfileStatColumnCard({
    super.key,
    required this.color,
    required this.titleColor,
    required this.subtitleColor,
    required this.value,
    required this.label,
    required this.svgAsset,
  });

  final Color color;
  final Color titleColor;
  final Color subtitleColor;
  final String value;
  final String label;
  final String svgAsset;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(AppRadius.radiusLg.r);
    final gradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color.lerp(color, GradientGlowTints.whiteVeil, 0.12) ?? color,
        color,
      ],
    );
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: radius,
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: radius,
        clipBehavior: Clip.hardEdge,
        child: Stack(
          clipBehavior: Clip.hardEdge,
          children: [
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(gradient: gradient),
              ),
            ),
            Positioned(
              top: -58.h,
              left: 0,
              right: 0,
              child: IgnorePointer(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: GradientGlowTints.whiteVeil.withValues(
                        alpha: 0.15,
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: SizedBox(width: 150.w, height: 150.w),
                  ),
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  AppSpacing.spacingLg.w,
                  AppSpacing.spacing2xl.h,
                  AppSpacing.spacingLg.w,
                  AppSpacing.spacing2xl.h,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(
                      svgAsset,
                      width: 32.w,
                      height: 32.h,
                      colorFilter: ColorFilter.mode(
                        titleColor,
                        BlendMode.srcIn,
                      ),
                    ),
                    SizedBox(height: AppSpacing.spacingLg.h),
                    Text(
                      value,
                      textAlign: TextAlign.center,
                      style: AppTypography.h5(color: titleColor),
                    ),
                    Text(
                      label,
                      textAlign: TextAlign.center,
                      style: AppTypography.bodySmall(color: subtitleColor),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
