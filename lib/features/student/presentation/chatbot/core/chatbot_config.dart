/// Defaults for Elara chat HTTP API ([OpenAPI](https://elara-chatbot-retrievel-api.onrender.com)).
abstract final class ChatbotConfig {
  /// Legacy hook - remote API uses [defaultSubject] instead of cluster ids.
  static const int defaultClusterId = 1;

  /// Sent with POST `/api/v1/chat` when a route does not provide a subject.
  static const String defaultSubject = 'physics';

  /// Fallback text if a legacy caller asks the backend to allocate a thread.
  static const String sessionStarterMessage = 'Hello';
}
