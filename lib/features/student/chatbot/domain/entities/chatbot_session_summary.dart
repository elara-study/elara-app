import 'package:equatable/equatable.dart';

/// Listed row for chat history (session id + display metadata).
class ChatbotSessionSummary extends Equatable {
  const ChatbotSessionSummary({
    required this.sessionId,
    this.title,
    this.lastUpdatedAt,
    this.lastMessagePreview,
  });

  final String sessionId;
  final String? title;

  /// Last activity time from backend (message or session update).
  final DateTime? lastUpdatedAt;

  /// Last message snippet for list subtitle.
  final String? lastMessagePreview;

  @override
  List<Object?> get props => [
    sessionId,
    title,
    lastUpdatedAt,
    lastMessagePreview,
  ];
}
