import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_radius.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// "My Children" title, subtitle, outline **Add** — Figma Children `205:2260`.
class ParentChildrenPageHeader extends StatelessWidget {
  const ParentChildrenPageHeader({super.key, this.onAddPressed});

  final VoidCallback? onAddPressed;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'My Children',
                style: AppTypography.h3(
                  color: cs.onSurface,
                ).copyWith(fontWeight: AppTypography.black),
              ),
              SizedBox(height: AppSpacing.spacing2xs.h),
              Text(
                'Manage and monitor progress',
                style: AppTypography.bodyLarge(color: cs.onSurfaceVariant),
              ),
            ],
          ),
        ),
        _AddOutlineButton(onPressed: onAddPressed),
      ],
    );
  }
}

class _AddOutlineButton extends StatelessWidget {
  const _AddOutlineButton({this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(AppRadius.radiusFull.r),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.spacingMd.w,
            vertical: AppSpacing.spacingSm.h,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.radiusFull.r),
            border: Border.all(color: AppColors.brandPrimary500),
          ),
          child: Text(
            '+ Add',
            style: AppTypography.labelLarge(
              color: AppColors.brandPrimary500,
            ).copyWith(fontWeight: FontWeight.w600, fontSize: 14.sp),
          ),
        ),
      ),
    );
  }
}
