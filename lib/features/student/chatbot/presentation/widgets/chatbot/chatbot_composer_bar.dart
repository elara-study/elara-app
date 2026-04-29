import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_shadows.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:elara/features/student/chatbot/presentation/widgets/chatbot/chatbot_screen_dimensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Bottom composer: rounded shell, attachment, text field, mic placeholder, send.
class ChatbotComposerBar extends StatelessWidget {
  const ChatbotComposerBar({
    super.key,
    required this.attachmentMenuAnchorKey,
    required this.textController,
    required this.isSending,
    required this.onAttachmentTap,
    required this.onSendTap,
  });

  final GlobalKey attachmentMenuAnchorKey;
  final TextEditingController textController;
  final bool isSending;
  final Future<void> Function() onAttachmentTap;
  final VoidCallback onSendTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return SafeArea(
      top: false,
      child: ClipRRect(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(28.r),
        ),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: cs.surface,
            boxShadow: AppShadows.dropShadow,
          ),
          padding: EdgeInsets.fromLTRB(
            AppSpacing.spacingMd.w,
            AppSpacing.spacingMd.h,
            AppSpacing.spacingMd.w,
            AppSpacing.spacingMd.h,
          ),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: cs.surfaceContainer,
              borderRadius: BorderRadius.circular(28.r),
              boxShadow: ChatbotScreenDimensions.composerInnerShadow,
            ),
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                4.w,
                AppSpacing.spacingXs.h,
                AppSpacing.spacingSm.w,
                AppSpacing.spacingXs.h,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                    key: attachmentMenuAnchorKey,
                    padding: EdgeInsets.only(left: 2.w),
                    icon: Icon(Icons.add_rounded, color: cs.primary),
                    onPressed: () => onAttachmentTap(),
                  ),
                  Expanded(
                    child: TextField(
                      controller: textController,
                      minLines: 1,
                      maxLines: 2,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(
                        hintText: 'Type a message...',
                        hintStyle: AppTypography.bodyMedium(
                          color: cs.onSurfaceVariant,
                        ),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.fromLTRB(
                          0,
                          AppSpacing.spacingMd.h,
                          AppSpacing.spacingSm.w,
                          AppSpacing.spacingMd.h,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 4.w),
                    child: Tooltip(
                      message: 'Voice input',
                      child: Icon(
                        Icons.mic_rounded,
                        color: ButtonColors.ghostText,
                        size: 24.sp,
                      ),
                    ),
                  ),
                  SizedBox(width: AppSpacing.spacingLg.w),
                  SizedBox(
                    width: 40.sp,
                    height: 40.sp,
                    child: Material(
                      color: ButtonColors.ghostText,
                      shape: const CircleBorder(),
                      clipBehavior: Clip.antiAlias,
                      child: InkWell(
                        onTap: isSending ? null : onSendTap,
                        child: Center(
                          child: isSending
                              ? SizedBox(
                                  width: 22.w,
                                  height: 22.w,
                                  child: const CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : Icon(
                                  Icons.send_rounded,
                                  color: Colors.white,
                                  size: 22.sp,
                                ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
