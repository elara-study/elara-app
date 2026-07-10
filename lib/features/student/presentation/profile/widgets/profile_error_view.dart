import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:elara/core/localization/localization_extension.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileErrorView extends StatelessWidget {
  const ProfileErrorView({
    super.key,
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.spacing2xl.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.wifi_off_rounded,
              size: 48.sp,
              color: AppColors.neutral300,
            ),
            SizedBox(height: AppSpacing.spacingLg.h),
            Text(
              message,
              style: AppTypography.bodyMedium(color: cs.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppSpacing.spacingXl.h),
            TextButton(
              onPressed: onRetry,
              child: Text(
                context.l10n.commonTryAgain,
                style: AppTypography.button(color: AppColors.brandPrimary500),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
