import 'package:elara/core/network/api_result.dart';
import 'package:elara/features/student/domain/chatbot/entities/chatbot_session_created.dart';
import 'package:elara/features/student/domain/chatbot/repositories/chatbot_repository.dart';

class CreateSessionUseCase {
  CreateSessionUseCase(this._repository);

  final ChatbotRepository _repository;

  Future<ApiResult<ChatbotSessionCreated>> call({
    required int clusterId,
    String? message,
    String? subject,
  }) => _repository.createSession(
    clusterId: clusterId,
    message: message,
    subject: subject,
  );
}
