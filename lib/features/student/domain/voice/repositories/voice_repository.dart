import 'dart:typed_data';

abstract class VoiceRepository {
  /// Transcribes audio bytes to text using Deepgram STT.
  Future<String> transcribeAudio(Uint8List audioBytes);

  /// Generates an assistant response using OpenRouter LLM.
  Future<String> generateResponse({
    required String userMessage,
    required List<Map<String, String>> conversationHistory,
  });

  /// Synthesizes text to speech using ElevenLabs TTS.
  /// Returns raw audio bytes (mp3).
  Future<Uint8List> synthesizeSpeech(String text);
}
