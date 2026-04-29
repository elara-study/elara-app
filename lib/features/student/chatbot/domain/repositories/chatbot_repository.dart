import 'package:elara/core/network/api_result.dart';
import 'package:elara/features/student/chatbot/domain/entities/assistant_reply.dart';
import 'package:elara/features/student/chatbot/domain/entities/chatbot_message.dart';
import 'package:elara/features/student/chatbot/domain/entities/chatbot_session_created.dart';
import 'package:elara/features/student/chatbot/domain/entities/chatbot_session_summary.dart';

/// AI chat sessions + messages — swap [MockChatbotRepository] for API-backed impl.
abstract class ChatbotRepository {
  Future<ApiResult<ChatbotSessionCreated>> createSession({
    required int clusterId,
  });

  Future<ApiResult<List<ChatbotSessionSummary>>> listSessions();

  Future<ApiResult<List<ChatbotMessage>>> loadHistory(String sessionId);

  Future<ApiResult<AssistantReply>> sendTextMessage({
    required String sessionId,
    required String text,
  });

  Future<ApiResult<AssistantReply>> sendImageMessage({
    required String sessionId,
    required String imageFilePath,
    required String captionOrPlaceholder,
  });

  /// Returns `true` when deletion succeeds ([ApiResult] carries bool like unit).
  Future<ApiResult<bool>> deleteSession(String sessionId);
}
