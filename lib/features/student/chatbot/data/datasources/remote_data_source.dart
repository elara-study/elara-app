import 'package:elara/features/student/chatbot/data/models/history_models.dart';
import 'package:elara/features/student/chatbot/data/models/send_response_model.dart';
import 'package:elara/features/student/chatbot/data/models/session_created_model.dart';
import 'package:elara/features/student/chatbot/data/models/session_summary_model.dart';

/// Remote AI chat API — paths live in [ApiConstants].
abstract class ChatbotRemoteDataSource {
  Future<SessionCreatedModel> createSession({required int clusterId});

  Future<List<SessionSummaryModel>> listSessions();

  Future<List<HistoryItemModel>> fetchHistory(String sessionId);

  Future<SendResponseModel> sendText({
    required String sessionId,
    required String text,
  });

  Future<SendResponseModel> sendImage({
    required String sessionId,
    required String imageFilePath,
    required String captionOrPlaceholder,
  });

  Future<void> deleteSession(String sessionId);
}
