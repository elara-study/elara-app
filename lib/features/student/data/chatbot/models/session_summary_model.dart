/// Row from GET sessions list.
class SessionSummaryModel {
  SessionSummaryModel({
    required this.sessionId,
    this.title,
    this.lastUpdatedAt,
    this.lastMessagePreview,
  });

  factory SessionSummaryModel.fromJson(Map<String, dynamic> json) {
    return SessionSummaryModel(
      sessionId:
          json['sessionId'] as String? ??
          json['session_id'] as String? ??
          json['id'] as String? ??
          json['conversationId'] as String? ??
          json['conversation_id'] as String? ??
          '',
      title:
          json['title'] as String? ??
          json['subject'] as String? ??
          json['name'] as String?,
      lastUpdatedAt: _parseDateTime(
        json['updatedAt'] ??
            json['updated_at'] ??
            json['lastMessageAt'] ??
            json['last_message_at'] ??
            json['modifiedAt'] ??
            json['modified_at'],
      ),
      lastMessagePreview: _readPreview(json),
    );
  }

  final String sessionId;
  final String? title;
  final DateTime? lastUpdatedAt;
  final String? lastMessagePreview;

  static String? _readPreview(Map<String, dynamic> json) {
    final direct =
        json['lastMessagePreview'] as String? ??
        json['last_message_preview'] as String? ??
        json['snippet'] as String? ??
        json['preview'] as String?;
    if (direct != null && direct.trim().isNotEmpty) {
      return direct.trim();
    }
    final last = json['lastMessage'];
    if (last is Map<String, dynamic>) {
      final content = last['content'] as String? ?? last['text'] as String?;
      if (content != null && content.trim().isNotEmpty) {
        return content.trim();
      }
    }
    return null;
  }

  static DateTime? _parseDateTime(Object? value) {
    if (value == null) {
      return null;
    }
    if (value is DateTime) {
      return value;
    }
    if (value is int) {
      final ms = value > 1000000000000 ? value : value * 1000;
      return DateTime.fromMillisecondsSinceEpoch(ms, isUtc: true).toLocal();
    }
    if (value is String) {
      final parsed = DateTime.tryParse(value);
      if (parsed != null) {
        return parsed.toLocal();
      }
    }
    return null;
  }
}
