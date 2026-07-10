/// POST /api/v1/chat mapping - tolerate enveloped and legacy key shapes.
class SessionCreatedModel {
  SessionCreatedModel({
    required this.sessionId,
    this.createdAt,
    this.clusterId,
    this.aiReply,
    this.subject,
  });

  factory SessionCreatedModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    final Map<String, dynamic> body;
    if (data is Map<String, dynamic>) {
      body = data;
    } else if (data is Map) {
      body = Map<String, dynamic>.from(data);
    } else {
      body = json;
    }
    final sid =
        body['sessionId'] as String? ??
        body['session_id'] as String? ??
        body['sessionid'] as String? ??
        body['id'] as String? ??
        body['conversationId'] as String? ??
        body['conversation_id'] as String? ??
        '';
    return SessionCreatedModel(
      sessionId: sid,
      createdAt: body['createdAt'] as String? ?? body['created_at'] as String?,
      clusterId: body['clusterId'] as int? ?? body['cluster_id'] as int?,
      aiReply:
          body['aiReply'] as String? ??
          body['ai_reply'] as String? ??
          body['reply'] as String? ??
          body['answer'] as String?,
      subject: body['subject'] as String?,
    );
  }

  final String sessionId;
  final String? createdAt;
  final int? clusterId;
  final String? aiReply;
  final String? subject;
}
