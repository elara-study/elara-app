/// Arguments for [AppRoutes.chatbot].
class ChatbotRouteArgs {
  const ChatbotRouteArgs({
    this.sessionId,
    this.sessionTitle,
    this.startNew = false,
  });

  final String? sessionId;
  final String? sessionTitle;
  final bool startNew;
}
