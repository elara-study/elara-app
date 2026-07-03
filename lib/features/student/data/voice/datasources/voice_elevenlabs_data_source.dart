import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class VoiceElevenLabsDataSource {
  VoiceElevenLabsDataSource({Dio? dio})
      : _dio = dio ?? Dio(BaseOptions(
            baseUrl: 'https://api.elevenlabs.io',
            connectTimeout: const Duration(seconds: 15),
            receiveTimeout: const Duration(seconds: 60),
          ));

  final Dio _dio;

  String get _apiKey => dotenv.env['ELEVENLABS_API_KEY'] ?? '';
  String get _voiceId => dotenv.env['ELEVENLABS_VOICE_ID'] ?? '21m00Tcm4TlvDq8ikWAM';

  Future<Uint8List> synthesize(String text) async {
    final response = await _dio.post(
      '/v1/text-to-speech/$_voiceId',
      data: {
        'text': text,
        'model_id': 'eleven_multilingual_v2',
        'voice_settings': {
          'stability': 0.5,
          'similarity_boost': 0.75,
          'style': 0.0,
          'use_speaker_boost': true,
        },
      },
      options: Options(
        headers: {
          'xi-api-key': _apiKey,
          'Content-Type': 'application/json',
          'Accept': 'audio/mpeg',
        },
        responseType: ResponseType.bytes,
        sendTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 60),
      ),
    );

    return Uint8List.fromList(response.data as List<int>);
  }
}
