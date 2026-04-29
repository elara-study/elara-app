import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:elara/features/student/chatbot/domain/entities/chatbot_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class ChatbotMessageTile extends StatelessWidget {
  const ChatbotMessageTile({super.key, required this.message});

  final ChatbotMessage message;

  static const Color _userBubble = AppColors.brandPrimary500;

  bool _isNetworkUrl(String path) => path.startsWith('http');

  String? _timeLabel() {
    final t = message.sentAt;
    if (t == null) return null;
    return DateFormat.jm().format(t.toLocal());
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isBot = message.isFromAssistant;
    final bubbleBg = isBot ? AppColors.brandPrimary500Alpha20 : _userBubble;
    final textColor = isBot ? cs.onSurface : AppColors.neutral50;
    final timeStyle = AppTypography.labelSmall(
      color: cs.onSecondary,
    ).copyWith(fontSize: 11.sp);

    final hasImage = message.imageUrl != null && message.imageUrl!.isNotEmpty;

    final bubble = DecoratedBox(
      decoration: BoxDecoration(
        color: bubbleBg,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(isBot ? 6.r : 18.r),
          topRight: Radius.circular(isBot ? 18.r : 6.r),
          bottomLeft: Radius.circular(18.r),
          bottomRight: Radius.circular(18.r),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.spacingMd.w),
        child: Column(
          crossAxisAlignment: hasImage
              ? CrossAxisAlignment.stretch
              : (isBot ? CrossAxisAlignment.start : CrossAxisAlignment.end),
          children: [
            if (hasImage) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: _buildImage(message.imageUrl!),
              ),
              SizedBox(height: AppSpacing.spacingSm.h),
            ],
            Text(
              message.text,
              textAlign: hasImage
                  ? (isBot ? TextAlign.left : TextAlign.right)
                  : null,
              style: AppTypography.bodyMedium(
                color: textColor,
              ).copyWith(height: 1.45),
            ),
            if (message.choices != null && message.choices!.isNotEmpty) ...[
              SizedBox(height: AppSpacing.spacingSm.h),
              Wrap(
                spacing: AppSpacing.spacingXs.w,
                runSpacing: AppSpacing.spacingXs.h,
                children: message.choices!.map((c) {
                  return Chip(
                    label: Text(
                      c,
                      style: AppTypography.bodySmall(color: cs.primary),
                    ),
                    visualDensity: VisualDensity.compact,
                    padding: EdgeInsets.zero,
                  );
                }).toList(),
              ),
            ],
          ],
        ),
      ),
    );

    final time = _timeLabel();
    final avatarBot = CircleAvatar(
      radius: 18.r,
      backgroundColor: cs.primary,
      child: Icon(Icons.smart_toy_rounded, size: 20.sp, color: cs.onPrimary),
    );
    final avatarUser = CircleAvatar(
      radius: 18.r,
      backgroundColor: AppColors.neutral300,
      child: Icon(
        Icons.person_rounded,
        size: 20.sp,
        color: AppColors.neutral600,
      ),
    );

    return Padding(
      padding: EdgeInsets.only(bottom: AppSpacing.spacingMd.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: isBot
            ? MainAxisAlignment.start
            : MainAxisAlignment.end,
        children: [
          if (isBot) ...[avatarBot, SizedBox(width: AppSpacing.spacingSm.w)],
          Flexible(
            child: Align(
              alignment: isBot ? Alignment.centerLeft : Alignment.centerRight,
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 0.68.sw),
                child: Column(
                  crossAxisAlignment: isBot
                      ? CrossAxisAlignment.start
                      : CrossAxisAlignment.end,
                  children: [
                    bubble,
                    if (time != null)
                      Padding(
                        padding: EdgeInsets.only(
                          top: AppSpacing.spacingXs.h,
                          left: isBot ? AppSpacing.spacingXs.w : 0,
                          right: isBot ? 0 : AppSpacing.spacingXs.w,
                        ),
                        child: Text(time, style: timeStyle),
                      ),
                  ],
                ),
              ),
            ),
          ),
          if (!isBot) ...[SizedBox(width: AppSpacing.spacingSm.w), avatarUser],
        ],
      ),
    );
  }

  Widget _buildImage(String url) {
    if (_isNetworkUrl(url)) {
      return CachedNetworkImage(
        imageUrl: url,
        fit: BoxFit.cover,
        width: double.infinity,
        height: 160.h,
        placeholder: (_, __) => SizedBox(
          height: 160.h,
          child: const Center(child: CircularProgressIndicator()),
        ),
        errorWidget: (_, __, ___) => const Icon(Icons.broken_image_outlined),
      );
    }
    final file = File(url);
    return Image.file(
      file,
      fit: BoxFit.cover,
      width: double.infinity,
      height: 160.h,
      errorBuilder: (_, __, ___) => const Icon(Icons.broken_image_outlined),
    );
  }
}
