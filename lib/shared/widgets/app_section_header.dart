import 'package:elara/core/theme/app_colors.dart';
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

  /// When provided, shows the Create button and opens the dialog on tap.
  final void Function(String title, String subject, String grade)?
  onCreateGroup;

  /// Controls the dialog's title + button label. Defaults to "Create a group".
  final GroupDialogConfig dialogConfig;

  const AppSectionHeader({
    super.key,
    required this.title,
    this.onSeeAll,
    this.seeAllLabel = 'See All',
    this.onCreateGroup,
    this.dialogConfig = const GroupDialogConfig(),
  });

  void _openDialog(BuildContext context) {
    String titleValue = '';
    String? subject;
    String? grade;

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (ctx, setDialogState) => GroupDialog(
          config: dialogConfig,
          titleValue: titleValue,
          selectedSubject: subject,
          selectedGrade: grade,
          onTitleChanged: (v) => setDialogState(() => titleValue = v),
          onSubjectChanged: (v) => setDialogState(() => subject = v),
          onGradeChanged: (v) => setDialogState(() => grade = v),
          onSubmit: () {
            if (titleValue.isEmpty || subject == null || grade == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Please fill all fields')),
              );
              return;
            }
            onCreateGroup?.call(titleValue, subject!, grade!);
            Navigator.of(ctx).pop();
          },
        ),
      ),
    );
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

        if (onCreateGroup != null)
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
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(
                    'assets/icons/plus_icon.svg',
                    width: AppSpacing.spacingLg.w,
                    height: AppSpacing.spacingLg.w,
                    colorFilter: const ColorFilter.mode(
                      AppColors.white,
                      BlendMode.srcIn,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    "Create", // reuse the config label
                    style: AppTypography.labelSmall(color: cs.onSurfaceVariant),
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
