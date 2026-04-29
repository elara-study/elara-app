import 'package:elara/core/network/api_result.dart';
import 'package:elara/features/student/chatbot/domain/entities/chatbot_session_created.dart';
import 'package:elara/features/student/chatbot/domain/repositories/chatbot_repository.dart';

class CreateSessionUseCase {
  CreateSessionUseCase(this._repository);

  final ChatbotRepository _repository;

  Future<ApiResult<ChatbotSessionCreated>> call({required int clusterId}) =>
      _repository.createSession(clusterId: clusterId);
}
