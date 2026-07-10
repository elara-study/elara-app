import 'dart:typed_data';

import 'package:elara/core/utils/logger.dart';
import 'package:elara/features/student/data/voice/datasources/voice_deepgram_data_source.dart';
import 'package:elara/features/student/data/voice/datasources/voice_elevenlabs_data_source.dart';
import 'package:elara/features/student/data/voice/datasources/voice_gemini_data_source.dart';
import 'package:elara/features/student/domain/voice/repositories/voice_repository.dart';

class VoiceRepositoryImpl implements VoiceRepository {
  VoiceRepositoryImpl(
    this._deepgram,
    this._gemini,
    this._elevenLabs,
  );

  final VoiceDeepgramDataSource _deepgram;
  final VoiceGeminiDataSource _gemini;
  final VoiceElevenLabsDataSource _elevenLabs;

  @override
  Future<String> transcribeAudio(Uint8List audioBytes) async {
    try {
      final transcript = await _deepgram.transcribe(audioBytes);
      AppLogger.info('Transcript: $transcript');
      return transcript;
    } catch (e, st) {
      AppLogger.error('Transcription failed', e, st);
      rethrow;
    }
  }

  @override
  Future<String> generateResponse({
    required String userMessage,
    required List<Map<String, String>> conversationHistory,
  }) async {
    try {
      final response = await _gemini.generateResponse(
        userMessage: userMessage,
        conversationHistory: conversationHistory,
      );
      AppLogger.info('LLM response: $response');
      return response;
    } catch (e, st) {
      AppLogger.error('Response generation failed', e, st);
      rethrow;
    }
  }

  @override
  Future<Uint8List> synthesizeSpeech(String text) async {
    try {
      final audio = await _elevenLabs.synthesize(text);
      AppLogger.info('Synthesized ${audio.length} bytes');
      return audio;
    } catch (e, st) {
      AppLogger.error('Speech synthesis failed', e, st);
      rethrow;
    }
  }
}
