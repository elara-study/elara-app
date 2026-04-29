import 'dart:io';

import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Caption + send row above the composer when an image is staged.
class ImagePreviewBar extends StatelessWidget {
  const ImagePreviewBar({
    super.key,
    required this.path,
    required this.captionController,
    required this.onCancel,
    required this.onSend,
    required this.isSending,
  });

  final String path;
  final TextEditingController captionController;
  final VoidCallback onCancel;
  final VoidCallback onSend;
  final bool isSending;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Material(
      elevation: 6,
      shadowColor: Colors.black26,
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.spacingMd.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child: Image.file(
                    File(path),
                    width: 72.w,
                    height: 72.w,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: AppSpacing.spacingMd.w),
                Expanded(
                  child: TextField(
                    controller: captionController,
                    decoration: InputDecoration(
                      hintText: 'Add a caption (optional)',
                      hintStyle: AppTypography.bodySmall(
                        color: cs.onSurfaceVariant,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: AppSpacing.spacingMd.w,
                        vertical: AppSpacing.spacingSm.h,
                      ),
                    ),
                    maxLines: 2,
                  ),
                ),
                IconButton(onPressed: onCancel, icon: const Icon(Icons.close)),
              ],
            ),
            SizedBox(height: AppSpacing.spacingSm.h),
            Align(
              alignment: Alignment.centerRight,
              child: FilledButton.icon(
                onPressed: isSending ? null : onSend,
                icon: isSending
                    ? SizedBox(
                        width: 18.w,
                        height: 18.w,
                        child: const CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.send_rounded),
                label: Text(isSending ? 'Sending…' : 'Send image'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
