import 'package:dio/dio.dart';
import 'package:elara/core/constants/api_constants.dart';
import 'package:elara/core/network/dio_client.dart';
import 'package:elara/features/student/data/chatbot/api_parsers.dart';
import 'package:elara/features/student/data/chatbot/datasources/remote_data_source.dart';
import 'package:elara/features/student/data/chatbot/models/history_models.dart';
import 'package:elara/features/student/data/chatbot/models/send_response_model.dart';
import 'package:elara/features/student/data/chatbot/models/session_created_model.dart';
import 'package:elara/features/student/data/chatbot/models/session_summary_model.dart';
import 'package:elara/features/student/presentation/chatbot/core/chatbot_config.dart';

class ChatbotRemoteDataSourceImpl implements ChatbotRemoteDataSource {
  ChatbotRemoteDataSourceImpl(this._dioClient);

  final DioClient _dioClient;

  Dio get _dio => _dioClient.dio;

  static const Map<String, dynamic> _defaultListQuery = {
    'page': '1',
    'limit': '20',
  };

  String _u(String relativePath) =>
      ApiConstants.chatUri(relativePath).toString();

  @override
  Future<SessionCreatedModel> createSession({
    required int clusterId,
    String? message,
    String? subject,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      _u(ApiConstants.chatbotStart),
      data: <String, dynamic>{
        'message': message ?? ChatbotConfig.sessionStarterMessage,
        'subject': subject ?? ChatbotConfig.defaultSubject,
      },
    );
    final data = response.data;
    if (data == null) {
      throw const FormatException('Empty body from POST /api/v1/chat');
    }
    return SessionCreatedModel.fromJson(data);
  }

  @override
  Future<List<SessionSummaryModel>> listSessions() async {
    final response = await _dio.get<Map<String, dynamic>>(
      _u(ApiConstants.chatbotConversations),
      queryParameters: _defaultListQuery,
    );
    final data = response.data;
    final rows = decodeObjectList(data);
    return rows.map(SessionSummaryModel.fromJson).toList();
  }

  @override
  Future<List<HistoryItemModel>> fetchHistory(String sessionId) async {
    final response = await _dio.get<Map<String, dynamic>>(
      _u(ApiConstants.chatbotConversation(sessionId)),
    );
    final data = response.data;
    return decodeConversationHistory(data);
  }

  @override
  Future<SendResponseModel> sendText({
    required String sessionId,
    required String text,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      _u(ApiConstants.chatbotConversationMessages(sessionId)),
      data: <String, dynamic>{'message': text},
    );
    final data = response.data;
    if (data == null) {
      throw const FormatException('Empty body from add message');
    }
    return SendResponseModel.fromJson(data);
  }

  @override
  Future<SendResponseModel> sendImage({
    required String sessionId,
    required String imageFilePath,
    required String captionOrPlaceholder,
  }) async {
    final image = await MultipartFile.fromFile(imageFilePath);
    final form = FormData.fromMap(<String, dynamic>{
      'message': captionOrPlaceholder,
      'image': image,
    });
    final response = await _dio.post<Map<String, dynamic>>(
      _u(ApiConstants.chatbotConversationMessages(sessionId)),
      data: form,
    );
    final data = response.data;
    if (data == null) {
      throw const FormatException('Empty body from image message');
    }
    return SendResponseModel.fromJson(data);
  }

  @override
  Future<void> deleteSession(String sessionId) async {
    await _dio.delete<void>(
      _u(ApiConstants.chatbotDeleteConversation(sessionId)),
    );
  }
}
