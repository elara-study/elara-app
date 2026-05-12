import 'package:elara/core/network/api_result.dart';
import 'package:elara/features/student/domain/chatbot/entities/assistant_reply.dart';
import 'package:elara/features/student/domain/chatbot/repositories/chatbot_repository.dart';

class SendTextUseCase {
  SendTextUseCase(this._repository);

  final ChatbotRepository _repository;

  Future<ApiResult<AssistantReply>> call({
    required String sessionId,
    required String text,
  }) => _repository.sendTextMessage(sessionId: sessionId, text: text);
}
