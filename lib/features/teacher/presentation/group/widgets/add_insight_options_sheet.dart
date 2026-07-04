import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_radius.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:elara/core/utils/app_snackbar.dart';
import 'package:elara/shared/widgets/app_form_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'add_insight_manual_sheet.dart';

/// Two-option dialog overlay for adding an insight (Figma 1417:7695).
Future<void> showAddInsightOptionsSheet(
  BuildContext context, {
  required String studentName,
}) {
  return showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (dialogContext) {
      final cs = Theme.of(dialogContext).colorScheme;
      return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.symmetric(horizontal: AppSpacing.spacingLg.w),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: BorderRadius.circular(AppRadius.radiusLg),
          ),
          child: Padding(
            padding: EdgeInsets.all(AppSpacing.spacingLg.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header with Title & Close Icon
                Row(
                  children: [
                    Text(
                      'Insight Options',
                      style: AppTypography.h4(
                        color: cs.onSurface,
                      ).copyWith(fontWeight: FontWeight.w800),
                    ),
                    const Spacer(),
                    AppFormDialogCloseButton(
                      onPressed: () => Navigator.of(dialogContext).pop(),
                    ),
                  ],
                ),
                SizedBox(height: AppSpacing.spacingLg.h),
                // Choices in a Row
                Row(
                  children: [
                    // Elara Option
                    Expanded(
                      child: Material(
                        color: AppColors.brandPrimary500,
                        borderRadius: BorderRadius.circular(AppRadius.radiusMd),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(
                            AppRadius.radiusMd,
                          ),
                          onTap: () {
                            Navigator.of(dialogContext).pop();
                            if (!context.mounted) return;
                            AppSnackBar.info(
                              context,
                              'Elara is drafting an insight for $studentName',
                            );
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 24.h),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.face_rounded,
                                  color: AppColors.white,
                                  size: 32.sp,
                                ),
                                SizedBox(height: AppSpacing.spacingXs.h),
                                Text(
                                  'elara',
                                  style: AppTypography.labelLarge(
                                    color: AppColors.white,
                                  ).copyWith(fontWeight: FontWeight.w800),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: AppSpacing.spacingMd.w),
                    // Manually Option
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.brandPrimary50,
                          borderRadius: BorderRadius.circular(
                            AppRadius.radiusMd,
                          ),
                          border: Border.all(
                            color: AppColors.brandPrimary500,
                            width: 1.5,
                          ),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(
                              AppRadius.radiusMd,
                            ),
                            onTap: () {
                              Navigator.of(dialogContext).pop();
                              if (!context.mounted) return;
                              showAddInsightManualSheet(
                                context,
                                studentName: studentName,
                              );
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 24.h),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.edit_rounded,
                                    color: AppColors.brandPrimary500,
                                    size: 32.sp,
                                  ),
                                  SizedBox(height: AppSpacing.spacingXs.h),
                                  Text(
                                    'Manually',
                                    style: AppTypography.labelLarge(
                                      color: AppColors.brandPrimary500,
                                    ).copyWith(fontWeight: FontWeight.w800),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppSpacing.spacingSm.h),
              ],
            ),
          ),
        ),
      );
    },
  );
}
