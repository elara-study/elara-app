import 'package:elara/core/theme/app_typography.dart';
import 'package:elara/features/student/chatbot/presentation/widgets/chatbot/chatbot_screen_dimensions.dart';
import 'package:elara/shared/widgets/app_glass_header.dart';
import 'package:flutter/material.dart';

/// Glass app bar for the chatbot conversation screen.
class ChatbotGlassAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ChatbotGlassAppBar({
    super.key,
    required this.sessionTitle,
    required this.onBack,
    required this.onOpenHistory,
  });

  final String? sessionTitle;
  final VoidCallback onBack;
  final VoidCallback onOpenHistory;

  @override
  Size get preferredSize =>
      const Size.fromHeight(ChatbotScreenDimensions.appBarHeight);

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return AppGlassHeader(
      height: ChatbotScreenDimensions.appBarHeight,
      title: 'elara',
      titleStyle: AppTypography.h5(
        font: 'Comfortaa',
        color: cs.onSurface,
      ).copyWith(fontWeight: FontWeight.w600),
      subtitle: sessionTitle ?? 'Ask anything about your lessons',
      subtitleStyle: AppTypography.bodySmall(color: cs.onSurfaceVariant),
      automaticallyImplyLeading: false,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_rounded),
        onPressed: onBack,
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.history_rounded),
          tooltip: 'Chat history',
          onPressed: onOpenHistory,
        ),
      ],
    );
  }
}
