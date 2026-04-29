import 'package:elara/core/network/network_info.dart';
import 'package:elara/features/student/chatbot/domain/entities/chatbot_session_summary.dart';
import 'package:elara/features/student/chatbot/domain/usecases/create_session_use_case.dart';
import 'package:elara/features/student/chatbot/domain/usecases/delete_session_use_case.dart';
import 'package:elara/features/student/chatbot/domain/usecases/list_sessions_use_case.dart';
import 'package:elara/features/student/chatbot/presentation/cubits/sessions_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SessionsCubit extends Cubit<SessionsState> {
  SessionsCubit({
    required ListSessionsUseCase listSessionsUseCase,
    required CreateSessionUseCase createSessionUseCase,
    required DeleteSessionUseCase deleteSessionUseCase,
    required NetworkInfo networkInfo,
    required int defaultClusterId,
  }) : _listSessionsUseCase = listSessionsUseCase,
       _createSessionUseCase = createSessionUseCase,
       _deleteSessionUseCase = deleteSessionUseCase,
       _networkInfo = networkInfo,
       _defaultClusterId = defaultClusterId,
       super(const SessionsState.initial());

  final ListSessionsUseCase _listSessionsUseCase;
  final CreateSessionUseCase _createSessionUseCase;
  final DeleteSessionUseCase _deleteSessionUseCase;
  final NetworkInfo _networkInfo;
  final int _defaultClusterId;

  Future<void> load({bool refresh = false}) async {
    if (state.status == SessionsStatus.loading && !refresh) return;

    emit(state.copyWith(status: SessionsStatus.loading, clearMessage: true));

    if (!await _networkInfo.isConnected) {
      emit(
        state.copyWith(
          status: SessionsStatus.failure,
          message: 'No internet connection',
        ),
      );
      return;
    }

    final result = await _listSessionsUseCase();
    if (!result.isSuccess || result.data == null) {
      emit(
        state.copyWith(
          status: SessionsStatus.failure,
          message: result.failure?.message ?? 'Failed to load chats',
        ),
      );
      return;
    }

    emit(state.copyWith(status: SessionsStatus.ready, sessions: result.data!));
  }

  void updateSearchQuery(String query) {
    emit(state.copyWith(searchQuery: query));
  }

  void clearSearch() {
    emit(state.copyWith(searchQuery: ''));
  }

  List<ChatbotSessionSummary> filteredSessions() {
    final q = state.searchQuery.trim().toLowerCase();
    if (q.isEmpty) return state.sessions;
    return state.sessions.where((s) {
      final title = (s.title ?? 'New Chat').toLowerCase();
      final preview = (s.lastMessagePreview ?? '').toLowerCase();
      return title.contains(q) || preview.contains(q);
    }).toList();
  }

  Future<bool> deleteSession(String sessionId) async {
    if (!await _networkInfo.isConnected) {
      emit(state.copyWith(message: 'No internet connection'));
      return false;
    }

    final result = await _deleteSessionUseCase(sessionId);
    if (!result.isSuccess) {
      emit(state.copyWith(message: result.failure?.message ?? 'Delete failed'));
      return false;
    }

    await load(refresh: true);
    return true;
  }

  /// Creates a backend session and returns its id for navigation.
  Future<String?> createSessionAndReturnId() async {
    if (!await _networkInfo.isConnected) {
      emit(state.copyWith(message: 'No internet connection'));
      return null;
    }

    final result = await _createSessionUseCase(clusterId: _defaultClusterId);
    if (!result.isSuccess || result.data == null) {
      emit(
        state.copyWith(
          message: result.failure?.message ?? 'Could not start chat',
        ),
      );
      return null;
    }

    final id = result.data!.sessionId;
    await load(refresh: true);
    return id;
  }
}
