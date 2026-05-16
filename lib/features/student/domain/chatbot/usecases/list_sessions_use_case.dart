import 'package:elara/core/network/api_result.dart';
import 'package:elara/features/student/domain/chatbot/entities/chatbot_session_summary.dart';
import 'package:elara/features/student/domain/chatbot/repositories/chatbot_repository.dart';

class ListSessionsUseCase {
  ListSessionsUseCase(this._repository);

  final ChatbotRepository _repository;

  Future<ApiResult<List<ChatbotSessionSummary>>> call() =>
      _repository.listSessions();
}
