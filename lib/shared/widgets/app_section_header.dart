import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_radius.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:elara/shared/widgets/create_group_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:elara/core/theme/app_spacing.dart';

class AppSectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onSeeAll;
  final String seeAllLabel;

  /// When provided, shows an outlined pill "+  Add" button.
  final VoidCallback? onAdd;

  /// When provided, shows the Create button and opens the dialog on tap.
  final void Function(String title, String subject, String grade, String roadmapName)?
  onCreateGroup;

  /// Controls the dialog's title + button label. Defaults to "Create a group".
  final GroupDialogConfig dialogConfig;

  /// Arbitrary widget rendered on the trailing (right) end.
  /// Takes precedence over [onCreateGroup], [onAdd], and [onSeeAll].
  final Widget? trailing;

  const AppSectionHeader({
    super.key,
    required this.title,
    this.onSeeAll,
    this.seeAllLabel = 'See All',
    this.onAdd,
    this.onCreateGroup,
    this.dialogConfig = const GroupDialogConfig(),
    this.trailing,
  });

  void _openDialog(BuildContext context) {
    if (onCreateGroup == null) return;
    GroupDialog.show(context, config: dialogConfig, onSubmit: onCreateGroup!);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: AppTypography.h4(
            color: cs.onSurface,
          ).copyWith(fontWeight: FontWeight.w900),
        ),

        if (trailing != null)
          trailing!
        else if (onCreateGroup != null)
          GestureDetector(
            onTap: () => _openDialog(context),
            behavior: HitTestBehavior.opaque,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.spacingMd.w,
                vertical: AppSpacing.spacingSm.h,
              ),
              decoration: BoxDecoration(
                color: cs.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(color: ButtonColors.outlineBorder),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(
                    'assets/icons/plus_icon.svg',
                    width: AppSpacing.spacingLg.w,
                    height: AppSpacing.spacingLg.w,
                    colorFilter: const ColorFilter.mode(
                      ButtonColors.outlineText,
                      BlendMode.srcIn,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    "Create",
                    style: AppTypography.labelSmall(color: cs.onSurfaceVariant),
                  ),
                ],
              ),
            ),
          )
        else if (onAdd != null)
          GestureDetector(
            onTap: onAdd,
            behavior: HitTestBehavior.opaque,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.spacingSm.w,
                vertical: AppSpacing.spacingXs.h,
              ),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.brandPrimary500),
                borderRadius: BorderRadius.circular(AppRadius.radiusFull.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(
                    'assets/icons/plus_icon.svg',
                    width: AppSpacing.spacingLg.w,
                    height: AppSpacing.spacingLg.w,
                    colorFilter: const ColorFilter.mode(
                      AppColors.brandPrimary500,
                      BlendMode.srcIn,
                    ),
                  ),
                  SizedBox(width: AppSpacing.spacingXs.w),
                  Text(
                    'Add',
                    style: AppTypography.labelSmall(
                      color: AppColors.brandPrimary500,
                    ),
                  ),
                ],
              ),
            ),
          )
        else if (onSeeAll != null)
          GestureDetector(
            onTap: onSeeAll,
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 4.h),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    seeAllLabel,
                    style: AppTypography.labelSmall(
                      color: ButtonColors.ghostText,
                    ),
                  ),
                  SizedBox(width: 2.w),
                  SvgPicture.asset(
                    'assets/icons/right_arrow_ios.svg',
                    width: AppSpacing.spacingLg.w,
                    height: AppSpacing.spacingLg.w,
                    colorFilter: const ColorFilter.mode(
                      ButtonColors.ghostText,
                      BlendMode.srcIn,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
