/// Defaults for Elara chat HTTP API ([OpenAPI](https://elara-chatbot-retrievel-api.onrender.com)).
abstract final class ChatbotConfig {
  /// Legacy hook — remote API uses [defaultSubject] instead of cluster ids.
  static const int defaultClusterId = 1;

  /// Sent with POST `/api/v1/chat` when the app creates an empty thread first.
  static const String defaultSubject = 'General';

  /// First hidden exchange when [createSession] maps to “start conversation”.
  static const String sessionStarterMessage = 'Hello';
}
