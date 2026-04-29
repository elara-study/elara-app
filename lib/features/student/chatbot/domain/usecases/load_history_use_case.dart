import 'package:elara/core/network/api_result.dart';
import 'package:elara/features/student/chatbot/domain/entities/chatbot_message.dart';
import 'package:elara/features/student/chatbot/domain/repositories/chatbot_repository.dart';

class LoadHistoryUseCase {
  LoadHistoryUseCase(this._repository);

  final ChatbotRepository _repository;

  Future<ApiResult<List<ChatbotMessage>>> call(String sessionId) =>
      _repository.loadHistory(sessionId);
}
