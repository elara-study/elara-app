import 'package:equatable/equatable.dart';

/// Single bubble in an AI chat thread (user or assistant).
class ChatbotMessage extends Equatable {
  const ChatbotMessage({
    required this.text,
    required this.isFromAssistant,
    this.choices,
    this.imageUrl,
    this.sentAt,
  });

  final String text;
  final bool isFromAssistant;
  final List<String>? choices;

  /// Remote URL or local `file://` path for previews.
  final String? imageUrl;

  /// When the message was sent (shown under bubbles when set).
  final DateTime? sentAt;

  @override
  List<Object?> get props => [text, isFromAssistant, choices, imageUrl, sentAt];
}
