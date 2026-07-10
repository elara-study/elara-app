import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class VoiceDeepgramDataSource {
  VoiceDeepgramDataSource({Dio? dio})
      : _dio = dio ?? Dio(BaseOptions(
            baseUrl: 'https://api.deepgram.com',
            connectTimeout: const Duration(seconds: 15),
            receiveTimeout: const Duration(seconds: 30),
          ));

  final Dio _dio;

  String get _apiKey => dotenv.env['DEEPGRAM_API_KEY'] ?? '';

  Future<String> transcribe(Uint8List audioBytes) async {
    final response = await _dio.post(
      '/v1/listen',
      data: audioBytes,
      options: Options(
        headers: {
          'Authorization': 'Token $_apiKey',
          'Content-Type': 'audio/mp4',
        },
        sendTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
      ),
      queryParameters: {
        'smart_format': 'true',
        'language': 'ar',
        'model': 'nova-3',
      },
    );

    final channels = response.data['results']?['channels'];
    if (channels == null || channels.isEmpty) {
      return '';
    }

    final alternatives =
        (channels as List).first['alternatives'] as List?;
    if (alternatives == null || alternatives.isEmpty) {
      return '';
    }

    return (alternatives.first['transcript'] as String?)?.trim() ?? '';
  }
}
