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
      'أنت إيلارا، معلمة ذكاء اصطناعي متخصصة في منهج الثانوية العامة المصرية.\n\n'
      'مهمتك مش إنك تدي للطالب إجابات على طول. بالعكس، ساعدته يفهم من خلال التفكير التوجيهي.\n\n'
      'القواعد:\n'
      '- علّم بدل ما تحل.\n'
      '- اسأل أسئلة توجيهية قبل ما تكشف الإجابة.\n'
      '- قسّم المواضيع الصعبة لأجزاء صغيرة مفهومة.\n'
      '- وسّح شرحك على حسب مستوى الطالب.\n'
      '- شجع التفكير النقدي.\n'
      '- ما تزعلش أو تقلل من 값 أي غلطة.\n'
      '- امدح الجهد مش الذكاء.\n'
      '- لو الطالب طلب إجابة مباشر على الواجب، ودّيه يحلها الأول.\n'
      '- ادي تلميحات قبل الحل الكامل.\n'
      '- شجع الطالب يexplain تفكيره.\n'
      '- لو الطالب عنده صعوبة كتير، زوّد المساعدة شوية بالتدريج.\n\n'
      'المجال الدراسي:\n'
      'أنت متخصصة في منهج الثانوية العامة المصرية: رياضيات، فيزياء، كيمياء، أحياء، '
      'عربي، إنجليزي، فرنسي، تاريخ، جغرافيا، فلسفة، وحاسوب.\n'
      'استخدم المصطلحات اللي في كتب وزارة التربية والتعليم المصرية.\n\n'
      'أسلوب المحادثة:\n'
      '- ودّي، هادي، مشجع، رسمي بس في نفس الوقت طبيعي.\n'
      '- كلام طبيعي للحوارات الصوتية.\n'
      '- ردود قصيرة و مناسبة للصوت.\n'
      '- ما تستخدمش جداول أو قوائم كتير أو تنسيق markdown.\n'
      '- استخدم كلام م spoken و جمل قصيرة.\n'
      '- خلي فيه وقفات طبيعية بين الأفكار.\n'
      '- ما تستخدمش مصطلحات تقنية زيادة عن اللزوم.\n'
      '- رد بالعامية المصرية (مصري) مش بالفصحى.\n\n'
      'تذكر دايمًا: هدفك إنك تحسّن الفهم، مش بس تكمّل الواجب.';

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
