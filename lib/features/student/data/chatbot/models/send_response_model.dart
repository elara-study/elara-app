import 'dart:convert';

/// POST send-message JSON — outer `{ timestamp, response: { message, choices } }`.
class SendResponseModel {
  SendResponseModel({required this.assistantMessage, this.choices});

  factory SendResponseModel.fromJson(Map<String, dynamic> json) {
    final inner =
        json['response'] as Map<String, dynamic>? ??
        json['data'] as Map<String, dynamic>? ??
        json;
    return SendResponseModel(
      assistantMessage:
          json['message'] as String? ??
          json['reply'] as String? ??
          json['answer'] as String? ??
          inner['message'] as String? ??
          inner['content'] as String? ??
          '',
      choices:
          _parseChoices(json['choices']) ?? _parseChoices(inner['choices']),
    );
  }

  final String assistantMessage;
  final List<String>? choices;

  static List<String>? _parseChoices(dynamic raw) {
    if (raw == null) return null;
    if (raw is List) return raw.cast<String>();
    if (raw is String) {
      try {
        final decoded = jsonDecode(raw);
        if (decoded is List) return decoded.cast<String>();
      } catch (_) {}
    }
    return null;
  }
}
