import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class VoiceGeminiDataSource {
  VoiceGeminiDataSource({Dio? dio})
      : _dio = dio ?? Dio(BaseOptions(
            baseUrl: 'https://openrouter.ai/api/v1',
            connectTimeout: const Duration(seconds: 15),
            receiveTimeout: const Duration(seconds: 60),
          ));

  final Dio _dio;

  String get _apiKey => dotenv.env['OPENROUTER_API_KEY'] ?? '';

  static const _systemPrompt =
      'You are Elara, an AI educational mentor specialized in the Egyptian secondary education system.\n\n'
      'Your mission is not to give students answers immediately. Instead, help them learn through guided reasoning.\n\n'
      'Rules:\n'
      '- Teach rather than solve.\n'
      '- Ask guiding questions before revealing answers.\n'
      '- Break complex topics into small understandable concepts.\n'
      '- Adapt explanations to the student level.\n'
      '- Encourage critical thinking.\n'
      '- Never shame or discourage mistakes.\n'
      '- Praise effort rather than intelligence.\n'
      '- If a student asks for homework answers directly, guide them toward solving it themselves first.\n'
      '- Give hints before full solutions.\n'
      '- Encourage students to explain their reasoning.\n'
      '- If the student struggles repeatedly, gradually increase the level of help.\n\n'
      'Educational Scope:\n'
      'You specialize in Egyptian Thanaweya Amma curriculum: Mathematics, Physics, Chemistry, Biology, '
      'Arabic, English, French, History, Geography, Philosophy, and Computer Science. '
      'When curriculum-specific terminology exists, prefer the terminology used in Egyptian Ministry of Education textbooks.\n\n'
      'Conversation Style:\n'
      '- Friendly, calm, encouraging, professional, conversational.\n'
      '- Natural for voice conversations.\n'
      '- Keep responses concise for voice output.\n'
      '- Avoid large bullet lists, markdown, code formatting, and tables.\n'
      '- Use spoken language with short sentences.\n'
      '- Pause naturally between ideas.\n'
      '- Avoid unnecessary technical jargon.\n\n'
      'Always remember: your goal is to improve understanding, not simply complete assignments.';

  static const _fallbackModels = [
    'google/gemma-4-26b-a4b-it:free',
    'nvidia/nemotron-3-super-120b-a12b:free',
    'google/gemma-4-31b-it:free',
  ];

  Future<String> generateResponse({
    required String userMessage,
    required List<Map<String, String>> conversationHistory,
  }) async {
    final messages = <Map<String, String>>[
      {'role': 'system', 'content': _systemPrompt},
      ...conversationHistory,
      {'role': 'user', 'content': userMessage},
    ];

    for (var attempt = 0; attempt < _fallbackModels.length; attempt++) {
      final model = _fallbackModels[attempt];
      try {
        final response = await _dio.post(
          '/chat/completions',
          data: {
            'model': model,
            'messages': messages,
            'max_tokens': 500,
            'temperature': 0.7,
          },
          options: Options(
            headers: {
              'Authorization': 'Bearer $_apiKey',
              'Content-Type': 'application/json',
              'HTTP-Referer': 'https://elara.app',
              'X-Title': 'Elara Voice Assistant',
            },
            sendTimeout: const Duration(seconds: 15),
            receiveTimeout: const Duration(seconds: 60),
          ),
        );

        final choices = response.data['choices'] as List?;
        if (choices == null || choices.isEmpty) continue;

        return (choices.first['message']?['content'] as String?)?.trim() ??
            'I apologize, I could not generate a response. Please try again.';
      } on DioException catch (e) {
        if (e.response?.statusCode == 429 && attempt < _fallbackModels.length - 1) {
          await Future.delayed(Duration(seconds: 2 * (attempt + 1)));
          continue;
        }
        rethrow;
      }
    }

    return 'I apologize, all models are currently busy. Please try again in a moment.';
  }
}
