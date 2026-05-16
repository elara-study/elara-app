import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_icon_sizes.dart';
import 'package:elara/core/theme/app_radius.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/shared/widgets/app_buttons.dart';
import 'package:elara/shared/widgets/app_dialog.dart';
import 'package:elara/shared/widgets/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

/// Modal dialog shown when teacher taps "+ Add Student".
class AddStudentDialog extends StatelessWidget {
  const AddStudentDialog({super.key});

  static Future<void> show(BuildContext context) {
    return AppDialog.show(
      context: context,
      builder: (ctx) => const AddStudentDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return AppDialog(
      title: 'Add a Student',
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Input field & QR code button
          Row(
            children: [
              const Expanded(
                child: AppTextField(hintText: "Enter student's username"),
              ),
              SizedBox(width: AppSpacing.spacingMd.w),
              GestureDetector(
                onTap: () {
                  //   Handle QR Scan
                },
                child: Container(
                  padding: EdgeInsets.all(14.w),
                  decoration: BoxDecoration(
                    color: ButtonColors.primaryDefault,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: SvgPicture.asset(
                    'assets/icons/qr_code.svg',
                    colorFilter: ColorFilter.mode(
                      cs.onSurface,
                      BlendMode.srcIn,
                    ),
                    width: AppIconSizes.iconSm.w,
                    height: AppIconSizes.iconSm.h,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.spacingLg.h),

          // Add Student Button
          SizedBox(
            width: double.infinity,
            child: AppPrimaryButton(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.spacingSm.w,
                vertical: AppSpacing.spacing2xs.h,
              ),
              text: 'Add Student',
              borderRadius: BorderRadius.circular(AppRadius.radiusFull.r),
              onPressed: () {
                Navigator.pop(context);
                //   Add student logic
              },
            ),
          ),
        ],
      ),
    );
  }
}
