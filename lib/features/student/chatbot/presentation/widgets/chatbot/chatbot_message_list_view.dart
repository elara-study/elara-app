import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/features/student/chatbot/domain/entities/chatbot_message.dart';
import 'package:elara/features/student/chatbot/presentation/widgets/message_tile.dart';
import 'package:elara/features/student/chatbot/presentation/widgets/today_chip.dart';
import 'package:elara/features/student/chatbot/presentation/widgets/typing_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Scrollable message list with optional today chip and typing row.
class ChatbotMessageListView extends StatelessWidget {
  const ChatbotMessageListView({
    super.key,
    required this.scrollController,
    required this.messages,
    required this.isAssistantTyping,
  });

  final ScrollController scrollController;
  final List<ChatbotMessage> messages;
  final bool isAssistantTyping;

  @override
  Widget build(BuildContext context) {
    final showTodayChip = messages.isNotEmpty || isAssistantTyping;
    final chipCount = showTodayChip ? 1 : 0;
    final typingExtra = isAssistantTyping ? 1 : 0;

    return ListView.builder(
      controller: scrollController,
      padding: EdgeInsets.fromLTRB(
        AppSpacing.spacingLg.w,
        AppSpacing.spacingMd.h,
        AppSpacing.spacingLg.w,
        AppSpacing.spacing6xl.h,
      ),
      itemCount: chipCount + messages.length + typingExtra,
      itemBuilder: (context, index) {
        if (showTodayChip && index == 0) {
          return const TodayChip();
        }
        final i = index - chipCount;
        if (isAssistantTyping && i == messages.length) {
          return const TypingIndicator();
        }
        return ChatbotMessageTile(message: messages[i]);
      },
    );
  }
}
