import 'package:elara/core/network/api_result.dart';
import 'package:elara/features/student/chatbot/domain/entities/chatbot_session_summary.dart';
import 'package:elara/features/student/chatbot/domain/repositories/chatbot_repository.dart';

class ListSessionsUseCase {
  ListSessionsUseCase(this._repository);

  final ChatbotRepository _repository;

  Future<ApiResult<List<ChatbotSessionSummary>>> call() =>
      _repository.listSessions();
}
