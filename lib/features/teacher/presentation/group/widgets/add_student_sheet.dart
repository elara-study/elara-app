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
import 'package:elara/core/localization/localization_extension.dart';

/// Modal dialog shown when teacher taps "+ Add Student".
class AddStudentDialog extends StatefulWidget {
  final String joinCode;
  final Function(String username) onSubmit;

  const AddStudentDialog({
    super.key,
    required this.joinCode,
    required this.onSubmit,
  });

  static Future<void> show(
    BuildContext context, {
    required String joinCode,
    required Function(String username) onSubmit,
  }) {
    return AppDialog.show(
      context: context,
      builder: (ctx) => AddStudentDialog(joinCode: joinCode, onSubmit: onSubmit),
    );
  }

  @override
  State<AddStudentDialog> createState() => _AddStudentDialogState();
}

class _AddStudentDialogState extends State<AddStudentDialog> {
  final TextEditingController _usernameController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return AppDialog(
      title: context.l10n.teacherAddStudentTitle,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Join Code Display
          Text(
            context.l10n.teacherGroupJoinCode,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: cs.onSurface,
                ),
          ),
          SizedBox(height: AppSpacing.spacingXs.h),
          Container(
            padding: EdgeInsets.symmetric(
              vertical: AppSpacing.spacingLg.h,
              horizontal: AppSpacing.spacingMd.w,
            ),
            decoration: BoxDecoration(
              color: cs.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(AppRadius.radiusMd.r),
              border: Border.all(color: cs.outlineVariant),
            ),
            alignment: Alignment.center,
            child: Text(
              widget.joinCode,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                    letterSpacing: 8,
                    color: AppColors.brandPrimary500,
                  ),
            ),
          ),
          SizedBox(height: AppSpacing.spacing2xl.h),

          // Input field & QR code button
          Row(
            children: [
              Expanded(
                child: AppTextField(
                  hintText: context.l10n.teacherEnterStudentUsername,
                  controller: _usernameController,
                ),
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
              text: context.l10n.teacherAddStudentTitle,
              borderRadius: BorderRadius.circular(AppRadius.radiusFull.r),
              onPressed: () {
                final username = _usernameController.text.trim();
                if (username.isNotEmpty) {
                  widget.onSubmit(username);
                  Navigator.pop(context);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
