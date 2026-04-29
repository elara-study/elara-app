import 'dart:io';

import 'package:elara/core/network/network_info.dart';
import 'package:elara/features/student/chatbot/domain/entities/chatbot_message.dart';
import 'package:elara/features/student/chatbot/domain/usecases/create_session_use_case.dart';
import 'package:elara/features/student/chatbot/domain/usecases/delete_session_use_case.dart';
import 'package:elara/features/student/chatbot/domain/usecases/list_sessions_use_case.dart';
import 'package:elara/features/student/chatbot/domain/usecases/load_history_use_case.dart';
import 'package:elara/features/student/chatbot/domain/usecases/send_image_use_case.dart';
import 'package:elara/features/student/chatbot/domain/usecases/send_text_use_case.dart';
import 'package:elara/features/student/chatbot/presentation/cubits/chatbot_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

/// Orchestrates one AI conversation thread.
class ChatbotCubit extends Cubit<ChatbotState> {
  ChatbotCubit({
    required CreateSessionUseCase createSessionUseCase,
    required ListSessionsUseCase listSessionsUseCase,
    required LoadHistoryUseCase loadHistoryUseCase,
    required SendTextUseCase sendTextUseCase,
    required SendImageUseCase sendImageUseCase,
    required DeleteSessionUseCase deleteSessionUseCase,
    required NetworkInfo networkInfo,
    required int defaultClusterId,
  }) : _createSessionUseCase = createSessionUseCase,
       _listSessionsUseCase = listSessionsUseCase,
       _loadHistoryUseCase = loadHistoryUseCase,
       _sendTextUseCase = sendTextUseCase,
       _sendImageUseCase = sendImageUseCase,
       _deleteSessionUseCase = deleteSessionUseCase,
       _networkInfo = networkInfo,
       _defaultClusterId = defaultClusterId,
       super(const ChatbotState.initial());

  final CreateSessionUseCase _createSessionUseCase;
  final ListSessionsUseCase _listSessionsUseCase;
  final LoadHistoryUseCase _loadHistoryUseCase;
  final SendTextUseCase _sendTextUseCase;
  final SendImageUseCase _sendImageUseCase;
  final DeleteSessionUseCase _deleteSessionUseCase;
  final NetworkInfo _networkInfo;
  final int _defaultClusterId;

  final ImagePicker _picker = ImagePicker();

  /// Boots the chat shell — optionally opens [routeSessionId] and loads history.
  Future<void> start({
    String? routeSessionId,
    String? routeSessionTitle,
  }) async {
    emit(
      const ChatbotState.initial().copyWith(
        loadError: null,
        sessionTitle: null,
      ),
    );

    if (!await _networkInfo.isConnected) {
      emit(
        state.copyWith(
          phase: ChatbotSessionPhase.ready,
          loadError: 'No internet connection',
        ),
      );
      return;
    }

    if (routeSessionId != null && routeSessionId.isNotEmpty) {
      emit(
        state.copyWith(
          phase: ChatbotSessionPhase.ready,
          sessionId: routeSessionId,
          sessionTitle: routeSessionTitle,
          messages: const [],
          clearLoadError: true,
        ),
      );
      await loadHistoryForCurrentSession();
      return;
    }

    final listResult = await _listSessionsUseCase();
    if (!listResult.isSuccess || listResult.data == null) {
      emit(
        state.copyWith(
          phase: ChatbotSessionPhase.ready,
          loadError:
              listResult.failure?.message ?? 'Could not reach the assistant',
        ),
      );
      return;
    }

    final sessions = listResult.data!;
    if (sessions.isEmpty) {
      final created = await _createSessionUseCase(clusterId: _defaultClusterId);
      if (!created.isSuccess || created.data == null) {
        emit(
          state.copyWith(
            phase: ChatbotSessionPhase.ready,
            loadError:
                created.failure?.message ?? 'Could not start a conversation',
          ),
        );
        return;
      }
      emit(
        state.copyWith(
          phase: ChatbotSessionPhase.ready,
          sessionId: created.data!.sessionId,
          messages: const [],
          clearLoadError: true,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        phase: ChatbotSessionPhase.ready,
        sessionId: sessions.first.sessionId,
        sessionTitle: sessions.first.title,
        messages: const [],
        clearLoadError: true,
      ),
    );
  }

  Future<void> loadHistoryForCurrentSession() async {
    final sid = state.sessionId;
    if (sid == null) return;

    emit(state.copyWith(isLoadingHistory: true, clearLoadError: true));
    final result = await _loadHistoryUseCase(sid);
    if (!result.isSuccess || result.data == null) {
      emit(
        state.copyWith(
          isLoadingHistory: false,
          bannerMessage: result.failure?.message ?? 'Failed to load history',
        ),
      );
      return;
    }

    emit(state.copyWith(isLoadingHistory: false, messages: result.data!));
  }

  Future<void> createNewChatSession() async {
    if (!await _networkInfo.isConnected) {
      emit(state.copyWith(bannerMessage: 'No internet connection'));
      return;
    }

    emit(state.copyWith(isSending: true));
    final result = await _createSessionUseCase(clusterId: _defaultClusterId);
    if (!result.isSuccess || result.data == null) {
      emit(
        state.copyWith(
          isSending: false,
          bannerMessage: result.failure?.message ?? 'Could not start chat',
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        isSending: false,
        sessionId: result.data!.sessionId,
        sessionTitle: null,
        messages: const [],
      ),
    );
  }

  Future<void> sendUserMessage(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty || state.isSending) return;

    if (!await _networkInfo.isConnected) {
      emit(state.copyWith(bannerMessage: 'No internet connection'));
      return;
    }

    var sid = state.sessionId;
    if (sid == null) {
      final created = await _createSessionUseCase(clusterId: _defaultClusterId);
      if (!created.isSuccess || created.data == null) {
        emit(
          state.copyWith(
            bannerMessage:
                created.failure?.message ?? 'Could not create a session',
          ),
        );
        return;
      }
      sid = created.data!.sessionId;
      emit(state.copyWith(sessionId: sid));
    }

    final userBubble = ChatbotMessage(
      text: trimmed,
      isFromAssistant: false,
      sentAt: DateTime.now(),
    );
    emit(
      state.copyWith(
        messages: [...state.messages, userBubble],
        isSending: true,
        isAssistantTyping: true,
        clearBanner: true,
      ),
    );

    final result = await _sendTextUseCase(sessionId: sid, text: trimmed);
    if (!result.isSuccess || result.data == null) {
      emit(
        state.copyWith(
          isSending: false,
          isAssistantTyping: false,
          messages: [
            ...state.messages,
            ChatbotMessage(
              text: result.failure?.message ?? 'Message failed to send',
              isFromAssistant: true,
              sentAt: DateTime.now(),
            ),
          ],
        ),
      );
      return;
    }

    final reply = result.data!;
    emit(
      state.copyWith(
        isSending: false,
        isAssistantTyping: false,
        messages: [
          ...state.messages,
          ChatbotMessage(
            text: reply.message,
            isFromAssistant: true,
            choices: reply.choices,
            sentAt: DateTime.now(),
          ),
        ],
      ),
    );
  }

  Future<void> pickImageForPreview(ImageSource source) async {
    try {
      final file = await _picker.pickImage(
        source: source,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );
      if (file == null) return;
      emit(state.copyWith(pendingImagePath: file.path));
    } catch (_) {
      emit(state.copyWith(bannerMessage: 'Could not access image'));
    }
  }

  void cancelImagePreview() {
    emit(state.copyWith(clearPendingImage: true));
  }

  Future<void> sendPendingImage({required String caption}) async {
    final path = state.pendingImagePath;
    if (path == null || state.isSending) return;

    if (!await _networkInfo.isConnected) {
      emit(state.copyWith(bannerMessage: 'No internet connection'));
      return;
    }

    var sid = state.sessionId;
    if (sid == null) {
      final created = await _createSessionUseCase(clusterId: _defaultClusterId);
      if (!created.isSuccess || created.data == null) {
        emit(
          state.copyWith(
            bannerMessage:
                created.failure?.message ?? 'Could not create a session',
          ),
        );
        return;
      }
      sid = created.data!.sessionId;
      emit(state.copyWith(sessionId: sid));
    }

    final display = caption.trim().isEmpty ? '[Image]' : caption.trim();
    final userBubble = ChatbotMessage(
      text: display,
      isFromAssistant: false,
      imageUrl: path.startsWith('http') ? path : path,
      sentAt: DateTime.now(),
    );

    emit(
      state.copyWith(
        messages: [...state.messages, userBubble],
        isSending: true,
        isAssistantTyping: true,
        clearPendingImage: true,
        clearBanner: true,
      ),
    );

    final captionOrPlaceholder = caption.trim().isEmpty
        ? 'Image uploaded'
        : caption.trim();

    final result = await _sendImageUseCase(
      sessionId: sid,
      imageFilePath: path,
      captionOrPlaceholder: captionOrPlaceholder,
    );

    if (!result.isSuccess || result.data == null) {
      emit(
        state.copyWith(
          isSending: false,
          isAssistantTyping: false,
          messages: [
            ...state.messages,
            ChatbotMessage(
              text: result.failure?.message ?? 'Image failed to send',
              isFromAssistant: true,
              sentAt: DateTime.now(),
            ),
          ],
        ),
      );
      return;
    }

    final reply = result.data!;
    emit(
      state.copyWith(
        isSending: false,
        isAssistantTyping: false,
        messages: [
          ...state.messages,
          ChatbotMessage(
            text: reply.message,
            isFromAssistant: true,
            choices: reply.choices,
            sentAt: DateTime.now(),
          ),
        ],
      ),
    );
  }

  Future<bool> deleteCurrentSession() async {
    final sid = state.sessionId;
    if (sid == null) return false;

    if (!await _networkInfo.isConnected) {
      emit(state.copyWith(bannerMessage: 'No internet connection'));
      return false;
    }

    final result = await _deleteSessionUseCase(sid);
    if (!result.isSuccess) {
      emit(
        state.copyWith(
          bannerMessage: result.failure?.message ?? 'Delete failed',
        ),
      );
      return false;
    }

    await createNewChatSession();
    return true;
  }

  void setScrollFabVisible(bool visible) {
    if (state.showScrollToBottomFab == visible) return;
    emit(state.copyWith(showScrollToBottomFab: visible));
  }

  void clearBanner() {
    emit(state.copyWith(clearBanner: true));
  }

  /// Whether [path] refers to a local file for [Image.file].
  bool isLocalFilePath(String path) {
    return path.startsWith('/') || (Platform.isWindows && path.contains(r'\'));
  }
}
