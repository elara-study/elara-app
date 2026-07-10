import 'dart:convert';

/// POST send-message JSON - reads AI text from nested payloads before envelopes.
class SendResponseModel {
  SendResponseModel({required this.assistantMessage, this.choices});

  factory SendResponseModel.fromJson(Map<String, dynamic> json) {
    final data = _asMap(json['data']);
    final response = _asMap(json['response']) ?? _asMap(data?['response']);
    return SendResponseModel(
      assistantMessage: _firstText([
        data?['aiReply'],
        data?['assistantReply'],
        data?['assistant_message'],
        data?['reply'],
        data?['answer'],
        data?['message'],
        data?['content'],
        response?['aiReply'],
        response?['assistantReply'],
        response?['assistant_message'],
        response?['reply'],
        response?['answer'],
        response?['message'],
        response?['content'],
        json['aiReply'],
        json['assistantReply'],
        json['assistant_message'],
        json['reply'],
        json['answer'],
        json['content'],
        json['message'],
      ]),
      choices:
          _parseChoices(data?['choices']) ??
          _parseChoices(response?['choices']) ??
          _parseChoices(json['choices']),
    );
  }

  final String assistantMessage;
  final List<String>? choices;

  static Map<String, dynamic>? _asMap(Object? raw) {
    if (raw is Map<String, dynamic>) return raw;
    if (raw is Map) return Map<String, dynamic>.from(raw);
    return null;
  }

  static String _firstText(List<Object?> values) {
    for (final value in values) {
      if (value is String && value.trim().isNotEmpty) {
        return value.trim();
      }
    }
    return '';
  }

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
