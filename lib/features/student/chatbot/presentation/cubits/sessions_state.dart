import 'package:elara/features/student/chatbot/domain/entities/chatbot_session_summary.dart';
import 'package:equatable/equatable.dart';

enum SessionsStatus { initial, loading, ready, failure }

class SessionsState extends Equatable {
  const SessionsState({
    required this.status,
    this.sessions = const [],
    this.searchQuery = '',
    this.message,
  });

  const SessionsState.initial() : this(status: SessionsStatus.initial);

  final SessionsStatus status;
  final List<ChatbotSessionSummary> sessions;
  final String searchQuery;

  /// Snackbar / banner copy for transient errors.
  final String? message;

  SessionsState copyWith({
    SessionsStatus? status,
    List<ChatbotSessionSummary>? sessions,
    String? searchQuery,
    String? message,
    bool clearMessage = false,
  }) {
    return SessionsState(
      status: status ?? this.status,
      sessions: sessions ?? this.sessions,
      searchQuery: searchQuery ?? this.searchQuery,
      message: clearMessage ? null : (message ?? this.message),
    );
  }

  @override
  List<Object?> get props => [status, sessions, searchQuery, message];
}
