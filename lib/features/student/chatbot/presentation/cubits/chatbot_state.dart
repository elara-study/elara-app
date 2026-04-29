import 'package:elara/features/student/chatbot/domain/entities/chatbot_message.dart';
import 'package:equatable/equatable.dart';

enum ChatbotSessionPhase { initializing, ready }

/// Single-thread AI chat UI state.
class ChatbotState extends Equatable {
  const ChatbotState({
    required this.phase,
    this.messages = const [],
    this.sessionId,
    this.sessionTitle,
    this.isLoadingHistory = false,
    this.isSending = false,
    this.isAssistantTyping = false,
    this.pendingImagePath,
    this.showScrollToBottomFab = false,
    this.bannerMessage,
    this.loadError,
  });

  const ChatbotState.initial() : this(phase: ChatbotSessionPhase.initializing);

  final ChatbotSessionPhase phase;
  final List<ChatbotMessage> messages;
  final String? sessionId;
  final String? sessionTitle;

  final bool isLoadingHistory;
  final bool isSending;
  final bool isAssistantTyping;

  /// Local path chosen from gallery/camera — preview only.
  final String? pendingImagePath;

  final bool showScrollToBottomFab;

  /// Snackbar — transient.
  final String? bannerMessage;

  /// Full-screen error while initializing / loading history.
  final String? loadError;

  ChatbotState copyWith({
    ChatbotSessionPhase? phase,
    List<ChatbotMessage>? messages,
    String? sessionId,
    String? sessionTitle,
    bool? isLoadingHistory,
    bool? isSending,
    bool? isAssistantTyping,
    String? pendingImagePath,
    bool clearPendingImage = false,
    bool? showScrollToBottomFab,
    String? bannerMessage,
    bool clearBanner = false,
    String? loadError,
    bool clearLoadError = false,
  }) {
    return ChatbotState(
      phase: phase ?? this.phase,
      messages: messages ?? this.messages,
      sessionId: sessionId ?? this.sessionId,
      sessionTitle: sessionTitle ?? this.sessionTitle,
      isLoadingHistory: isLoadingHistory ?? this.isLoadingHistory,
      isSending: isSending ?? this.isSending,
      isAssistantTyping: isAssistantTyping ?? this.isAssistantTyping,
      pendingImagePath: clearPendingImage
          ? null
          : (pendingImagePath ?? this.pendingImagePath),
      showScrollToBottomFab:
          showScrollToBottomFab ?? this.showScrollToBottomFab,
      bannerMessage: clearBanner ? null : (bannerMessage ?? this.bannerMessage),
      loadError: clearLoadError ? null : (loadError ?? this.loadError),
    );
  }

  @override
  List<Object?> get props => [
    phase,
    messages,
    sessionId,
    sessionTitle,
    isLoadingHistory,
    isSending,
    isAssistantTyping,
    pendingImagePath,
    showScrollToBottomFab,
    bannerMessage,
    loadError,
  ];
}
