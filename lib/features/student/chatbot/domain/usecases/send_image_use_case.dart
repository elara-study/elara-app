import 'package:elara/core/network/api_result.dart';
import 'package:elara/features/student/chatbot/domain/entities/assistant_reply.dart';
import 'package:elara/features/student/chatbot/domain/repositories/chatbot_repository.dart';

class SendImageUseCase {
  SendImageUseCase(this._repository);

  final ChatbotRepository _repository;

  Future<ApiResult<AssistantReply>> call({
    required String sessionId,
    required String imageFilePath,
    required String captionOrPlaceholder,
  }) => _repository.sendImageMessage(
    sessionId: sessionId,
    imageFilePath: imageFilePath,
    captionOrPlaceholder: captionOrPlaceholder,
  );
}
