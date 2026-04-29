import 'package:dio/dio.dart';
import 'package:elara/core/constants/api_constants.dart';
import 'package:elara/core/error/failures.dart';
import 'package:elara/core/network/api_result.dart';
import 'package:elara/features/student/chatbot/data/datasources/remote_data_source.dart';
import 'package:elara/features/student/chatbot/data/models/history_models.dart';
import 'package:elara/features/student/chatbot/domain/entities/assistant_reply.dart';
import 'package:elara/features/student/chatbot/domain/entities/chatbot_message.dart';
import 'package:elara/features/student/chatbot/domain/entities/chatbot_session_created.dart';
import 'package:elara/features/student/chatbot/domain/entities/chatbot_session_summary.dart';
import 'package:elara/features/student/chatbot/domain/repositories/chatbot_repository.dart';

/// Maps [ChatbotRemoteDataSource] + JSON models to domain entities.
class ChatbotRepositoryImpl implements ChatbotRepository {
  ChatbotRepositoryImpl(this._remote);

  final ChatbotRemoteDataSource _remote;

  @override
  Future<ApiResult<ChatbotSessionCreated>> createSession({
    required int clusterId,
  }) async {
    try {
      final m = await _remote.createSession(clusterId: clusterId);
      if (m.sessionId.isEmpty) {
        return ApiResult.failure(const ServerFailure('Invalid session id'));
      }
      return ApiResult.success(
        ChatbotSessionCreated(
          sessionId: m.sessionId,
          createdAt: m.createdAt,
          clusterId: m.clusterId,
        ),
      );
    } on DioException catch (e) {
      return ApiResult.failure(_mapDio(e));
    } catch (e) {
      return ApiResult.failure(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<ApiResult<List<ChatbotSessionSummary>>> listSessions() async {
    try {
      final list = await _remote.listSessions();
      return ApiResult.success(
        list
            .map(
              (m) => ChatbotSessionSummary(
                sessionId: m.sessionId,
                title: m.title,
                lastUpdatedAt: m.lastUpdatedAt,
                lastMessagePreview: m.lastMessagePreview,
              ),
            )
            .toList(),
      );
    } on DioException catch (e) {
      return ApiResult.failure(_mapDio(e));
    } catch (e) {
      return ApiResult.failure(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<ApiResult<List<ChatbotMessage>>> loadHistory(String sessionId) async {
    try {
      final items = await _remote.fetchHistory(sessionId);
      final messages = items.map(_historyItemToEntity).toList();
      return ApiResult.success(messages);
    } on DioException catch (e) {
      return ApiResult.failure(_mapDio(e));
    } catch (e) {
      return ApiResult.failure(UnknownFailure(e.toString()));
    }
  }

  ChatbotMessage _historyItemToEntity(HistoryItemModel m) {
    String? url = m.imageUrl;
    if (url != null && url.isNotEmpty && url.startsWith('/uploads/')) {
      url = ApiConstants.resolveAssetUrl(url);
    }
    return ChatbotMessage(
      text: m.content,
      isFromAssistant: !m.isFromUser,
      choices: m.choices,
      imageUrl: url,
    );
  }

  @override
  Future<ApiResult<AssistantReply>> sendTextMessage({
    required String sessionId,
    required String text,
  }) async {
    try {
      final m = await _remote.sendText(sessionId: sessionId, text: text);
      return ApiResult.success(
        AssistantReply(message: m.assistantMessage, choices: m.choices),
      );
    } on DioException catch (e) {
      return ApiResult.failure(_mapDio(e));
    } catch (e) {
      return ApiResult.failure(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<ApiResult<AssistantReply>> sendImageMessage({
    required String sessionId,
    required String imageFilePath,
    required String captionOrPlaceholder,
  }) async {
    try {
      final m = await _remote.sendImage(
        sessionId: sessionId,
        imageFilePath: imageFilePath,
        captionOrPlaceholder: captionOrPlaceholder,
      );
      return ApiResult.success(
        AssistantReply(message: m.assistantMessage, choices: m.choices),
      );
    } on DioException catch (e) {
      return ApiResult.failure(_mapDio(e));
    } catch (e) {
      return ApiResult.failure(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<ApiResult<bool>> deleteSession(String sessionId) async {
    try {
      await _remote.deleteSession(sessionId);
      return ApiResult.success(true);
    } on DioException catch (e) {
      return ApiResult.failure(_mapDio(e));
    } catch (e) {
      return ApiResult.failure(UnknownFailure(e.toString()));
    }
  }

  Failure _mapDio(DioException e) {
    final msg = e.message ?? 'Network error';
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.connectionError ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout) {
      return NetworkFailure(msg);
    }
    final data = e.response?.data;
    if (data is Map && data['message'] is String) {
      return ServerFailure(data['message'] as String);
    }
    if (data is Map && data['error'] is String) {
      return ServerFailure(data['error'] as String);
    }
    return ServerFailure(msg);
  }
}
