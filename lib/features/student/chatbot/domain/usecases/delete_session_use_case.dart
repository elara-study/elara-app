import 'package:elara/core/network/api_result.dart';
import 'package:elara/features/student/chatbot/domain/repositories/chatbot_repository.dart';

class DeleteSessionUseCase {
  DeleteSessionUseCase(this._repository);

  final ChatbotRepository _repository;

  Future<ApiResult<bool>> call(String sessionId) =>
      _repository.deleteSession(sessionId);
}
