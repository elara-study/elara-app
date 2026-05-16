/// POST /sessions JSON payload mapping — tolerate camelCase / snake_case keys.
class SessionCreatedModel {
  SessionCreatedModel({
    required this.sessionId,
    this.createdAt,
    this.clusterId,
  });

  factory SessionCreatedModel.fromJson(Map<String, dynamic> json) {
    final sid =
        json['sessionId'] as String? ??
        json['session_id'] as String? ??
        json['sessionid'] as String? ??
        json['id'] as String? ??
        json['conversationId'] as String? ??
        json['conversation_id'] as String? ??
        '';
    return SessionCreatedModel(
      sessionId: sid,
      createdAt: json['createdAt'] as String? ?? json['created_at'] as String?,
      clusterId: json['clusterId'] as int? ?? json['cluster_id'] as int?,
    );
  }

  final String sessionId;
  final String? createdAt;
  final int? clusterId;
}
