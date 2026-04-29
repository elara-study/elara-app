import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_radius.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

Future<ImageSource?> showAttachmentMenu({
  required BuildContext context,
  required GlobalKey anchorKey,
}) async {
  final buttonContext = anchorKey.currentContext;
  if (buttonContext == null) return null;

  final button = buttonContext.findRenderObject()! as RenderBox;
  final overlay =
      Navigator.of(context).overlay!.context.findRenderObject()! as RenderBox;

  final position = RelativeRect.fromRect(
    Rect.fromPoints(
      button.localToGlobal(Offset.zero),
      button.localToGlobal(button.size.bottomRight(Offset.zero)),
    ),
    Offset.zero & overlay.size,
  );

  final labelStyle = AppTypography.labelSmall(
    color: AppColors.brandPrimary500,
  ).copyWith(height: 16 / 12);

  return showMenu<ImageSource>(
    context: context,
    position: position,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppRadius.radiusSm.r),
    ),
    color: Colors.white,
    elevation: 8,
    shadowColor: const Color(0x26000000),
    menuPadding: EdgeInsets.zero,
    constraints: BoxConstraints(minWidth: 168.w),
    items: [
      PopupMenuItem<ImageSource>(
        value: ImageSource.gallery,
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.spacingSm.w,
          vertical: AppSpacing.spacingXs.h,
        ),
        height: 40.h,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.photo_library_outlined,
              size: 16.sp,
              color: AppColors.brandPrimary500,
            ),
            SizedBox(width: AppSpacing.spacingXs.w),
            Text('Upload Photo', style: labelStyle),
          ],
        ),
      ),
      PopupMenuItem<ImageSource>(
        value: ImageSource.camera,
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.spacingSm.w,
          vertical: AppSpacing.spacingXs.h,
        ),
        height: 40.h,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.photo_camera_outlined,
              size: 16.sp,
              color: AppColors.brandPrimary500,
            ),
            SizedBox(width: AppSpacing.spacingXs.w),
            Text('Use Camera', style: labelStyle),
          ],
        ),
      ),
    ],
  );
}
