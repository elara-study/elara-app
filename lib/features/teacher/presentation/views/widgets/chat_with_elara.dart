import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_radius.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:elara/core/theme/app_spacing.dart';

class ChatWithElaraCard extends StatelessWidget {
  final VoidCallback onTap;
  final bool isSelected;

  const ChatWithElaraCard({
    super.key,
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
        height: 56.h,
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.spacingLg.w),
        decoration: BoxDecoration(
          color: ButtonColors.primaryDefault,
          borderRadius: BorderRadius.circular(AppRadius.radiusMd.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/icons/elara_icon.svg',
              width: 20.w,
              height: 20.w,
              colorFilter: const ColorFilter.mode(
                ButtonColors.primaryText,
                BlendMode.srcIn,
              ),
            ),
            SizedBox(width: AppSpacing.spacingMd.w),
            Text(
              'Chat with elara',
              style: AppTypography.h6(
                color: ButtonColors.primaryText,
              ).copyWith(fontWeight: AppTypography.extraBold),
            ),
          ],
        ),
      ),
    );
  }
}
