import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_radius.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

Future<void> showProfileLinkParentSheet(BuildContext context) {
  return showDialog<void>(
    context: context,
    builder: (ctx) {
      final bottom = MediaQuery.viewInsetsOf(ctx).bottom;
      return AnimatedPadding(
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        padding: EdgeInsets.only(bottom: bottom),
        child: Dialog(
          insetPadding: EdgeInsets.symmetric(
            horizontal: AppSpacing.spacingLg.w,
            vertical: AppSpacing.spacingLg.h,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.radiusLg.r),
          ),
          child: const ProfileLinkParentSheet(),
        ),
      );
    },
  );
}

class ProfileLinkParentSheet extends StatefulWidget {
  const ProfileLinkParentSheet({super.key});

  @override
  State<ProfileLinkParentSheet> createState() => _ProfileLinkParentSheetState();
}

class _ProfileLinkParentSheetState extends State<ProfileLinkParentSheet> {
  final _usernameController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  void _submit() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(AppSpacing.spacingLg.r),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  'Link a Parent',
                  style: AppTypography.h5(color: AppColors.neutral900),
                ),
              ),
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                style: IconButton.styleFrom(
                  minimumSize: Size(20.w, 20.h),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  padding: EdgeInsets.zero,
                ),
                icon: SvgPicture.asset(
                  'assets/icons/clear_icon.svg',
                  width: 20.w,
                  height: 20.h,
                  colorFilter: const ColorFilter.mode(
                    AppColors.neutral900,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.spacingLg.h),
          TextField(
            controller: _usernameController,
            style: AppTypography.bodySmall(color: AppColors.neutral900),
            decoration: InputDecoration(
              hintText: "Enter your parent's username",
              hintStyle: AppTypography.bodySmall(
                color: AppColors.neutral500,
              ).copyWith(height: 18 / 12),
              filled: true,
              fillColor: AppColors.neutral50,
              contentPadding: EdgeInsets.symmetric(
                horizontal: AppSpacing.spacingMd.w,
                vertical: AppSpacing.spacingSm.h,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.radiusMd.r),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.radiusMd.r),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.radiusMd.r),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          SizedBox(height: AppSpacing.spacingLg.h),
          FilledButton(
            onPressed: _submit,
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.brandPrimary500,
              foregroundColor: AppColors.white,
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.spacingSm.w,
                vertical: AppSpacing.spacingXs.h,
              ),
              minimumSize: Size(double.infinity, 40.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.radiusFull.r),
              ),
            ),
            child: Text(
              'Link Parent',
              style: AppTypography.labelSmall(
                color: AppColors.white,
              ).copyWith(height: 16 / 12),
            ),
          ),
          SizedBox(height: AppSpacing.spacingSm.h),
        ],
      ),
    );
  }
}
