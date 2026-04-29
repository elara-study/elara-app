import 'package:equatable/equatable.dart';

/// Response when the backend allocates a new conversation session.
class ChatbotSessionCreated extends Equatable {
  const ChatbotSessionCreated({
    required this.sessionId,
    this.createdAt,
    this.clusterId,
  });

  final String sessionId;
  final String? createdAt;
  final int? clusterId;

  @override
  List<Object?> get props => [sessionId, createdAt, clusterId];
}
