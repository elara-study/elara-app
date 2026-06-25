import 'package:equatable/equatable.dart';

/// Response when the backend allocates a new conversation session.
class ChatbotSessionCreated extends Equatable {
  const ChatbotSessionCreated({
    required this.sessionId,
    this.createdAt,
    this.clusterId,
    this.aiReply,
    this.subject,
  });

  final String sessionId;
  final String? createdAt;
  final int? clusterId;
  final String? aiReply;
  final String? subject;

  @override
  List<Object?> get props => [sessionId, createdAt, clusterId, aiReply, subject];
}
