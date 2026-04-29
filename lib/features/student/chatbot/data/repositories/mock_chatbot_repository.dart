import 'package:elara/core/error/failures.dart';
import 'package:elara/core/network/api_result.dart';
import 'package:elara/features/student/chatbot/domain/entities/assistant_reply.dart';
import 'package:elara/features/student/chatbot/domain/entities/chatbot_message.dart';
import 'package:elara/features/student/chatbot/domain/entities/chatbot_session_created.dart';
import 'package:elara/features/student/chatbot/domain/entities/chatbot_session_summary.dart';
import 'package:elara/features/student/chatbot/domain/repositories/chatbot_repository.dart';

/// In-memory AI chat — swap for [ChatbotRepositoryImpl] when API matches routes.
class MockChatbotRepository implements ChatbotRepository {
  final Map<String, List<ChatbotMessage>> _messagesBySession = {};
  final List<ChatbotSessionSummary> _sessions = [];

  int _counter = 0;

  String _nextSessionId() {
    _counter++;
    return 'mock-session-$_counter';
  }

  void _touchSessionMeta(String sessionId, String preview) {
    final idx = _sessions.indexWhere((s) => s.sessionId == sessionId);
    if (idx < 0) return;
    final cur = _sessions[idx];
    String? title = cur.title;
    if (title == null || title.isEmpty) {
      final t = preview.length > 42 ? '${preview.substring(0, 42)}…' : preview;
      title = t;
    }
    final clipped = preview.length > 80
        ? '${preview.substring(0, 80)}…'
        : preview;
    _sessions[idx] = ChatbotSessionSummary(
      sessionId: sessionId,
      title: title,
      lastUpdatedAt: DateTime.now(),
      lastMessagePreview: clipped,
    );
  }

  String _replyFor(String userText) {
    final t = userText.trim().toLowerCase();
    if (t.contains('hello') || t.contains('hi')) {
      return 'Hi there! How can I help you study today?';
    }
    if (t.contains('thanks')) {
      return 'You got it — anytime!';
    }
    return 'Thanks for your message. Try asking about a lesson topic or '
        'upload a photo of a problem for hints.';
  }

  @override
  Future<ApiResult<ChatbotSessionCreated>> createSession({
    required int clusterId,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 350));
    final id = _nextSessionId();
    _messagesBySession[id] = [];
    _sessions.insert(
      0,
      ChatbotSessionSummary(
        sessionId: id,
        title: null,
        lastUpdatedAt: DateTime.now(),
        lastMessagePreview: null,
      ),
    );
    return ApiResult.success(
      ChatbotSessionCreated(sessionId: id, clusterId: clusterId),
    );
  }

  @override
  Future<ApiResult<List<ChatbotSessionSummary>>> listSessions() async {
    await Future<void>.delayed(const Duration(milliseconds: 280));
    return ApiResult.success(List<ChatbotSessionSummary>.from(_sessions));
  }

  @override
  Future<ApiResult<List<ChatbotMessage>>> loadHistory(String sessionId) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    final list = _messagesBySession[sessionId];
    if (list == null) {
      return ApiResult.failure(const ServerFailure('Session not found'));
    }
    return ApiResult.success(List<ChatbotMessage>.from(list));
  }

  @override
  Future<ApiResult<AssistantReply>> sendTextMessage({
    required String sessionId,
    required String text,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 450));
    final msgs = _messagesBySession.putIfAbsent(sessionId, () => []);
    final now = DateTime.now();
    msgs.add(ChatbotMessage(text: text, isFromAssistant: false, sentAt: now));
    final replyText = _replyFor(text);
    msgs.add(
      ChatbotMessage(
        text: replyText,
        isFromAssistant: true,
        sentAt: DateTime.now(),
      ),
    );
    _touchSessionMeta(sessionId, text);
    return ApiResult.success(AssistantReply(message: replyText));
  }

  @override
  Future<ApiResult<AssistantReply>> sendImageMessage({
    required String sessionId,
    required String imageFilePath,
    required String captionOrPlaceholder,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    final msgs = _messagesBySession.putIfAbsent(sessionId, () => []);
    final label = captionOrPlaceholder.trim().isEmpty
        ? '[Image]'
        : captionOrPlaceholder;
    msgs.add(
      ChatbotMessage(
        text: label,
        isFromAssistant: false,
        imageUrl: imageFilePath,
        sentAt: DateTime.now(),
      ),
    );
    const replyText =
        'I received your image. Describe what you would like help with, '
        'or ask about the steps shown.';
    msgs.add(
      ChatbotMessage(
        text: replyText,
        isFromAssistant: true,
        sentAt: DateTime.now(),
      ),
    );
    _touchSessionMeta(sessionId, label);
    return ApiResult.success(const AssistantReply(message: replyText));
  }

  @override
  Future<ApiResult<bool>> deleteSession(String sessionId) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    _messagesBySession.remove(sessionId);
    _sessions.removeWhere((s) => s.sessionId == sessionId);
    return ApiResult.success(true);
  }
}
