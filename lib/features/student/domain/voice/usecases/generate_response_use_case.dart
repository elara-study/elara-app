import 'package:elara/features/student/domain/voice/repositories/voice_repository.dart';

class GenerateResponseUseCase {
  const GenerateResponseUseCase(this._repository);

  final VoiceRepository _repository;

  Future<String> call({
    required String userMessage,
    required List<Map<String, String>> conversationHistory,
  }) {
    return _repository.generateResponse(
      userMessage: userMessage,
      conversationHistory: conversationHistory,
    );
  }
}
