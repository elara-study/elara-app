import 'dart:convert';

/// One row returned by GET conversation history.
class HistoryItemModel {
  HistoryItemModel({
    required this.content,
    required this.isFromUser,
    this.choices,
    this.imageUrl,
    this.createdAt,
  });

  factory HistoryItemModel.fromJson(Map<String, dynamic> json) {
    return HistoryItemModel(
      content:
          json['content'] as String? ??
          json['message'] as String? ??
          json['text'] as String? ??
          '',
      isFromUser: _inferIsFromUser(json),
      choices: _parseChoices(json['choices']),
      imageUrl: json['imageUrl'] as String? ?? json['image_url'] as String?,
      createdAt: _parseDateTime(json['createdAt'] ?? json['created_at']),
    );
  }

  static bool _inferIsFromUser(Map<String, dynamic> json) {
    final direct = json['isFromUser'] as bool? ?? json['is_from_user'] as bool?;
    if (direct != null) return direct;

    final rawRole = json['role'] ?? json['sender'] ?? json['from'];
    if (rawRole is num) {
      if (rawRole == 1) return true;
      if (rawRole == 2) return false;
    }

    final role = rawRole?.toString().toLowerCase();
    if (role == '1' || role == 'user' || role == 'student') return true;
    if (role == '2' || role == 'assistant' || role == 'bot') return false;
    return false;
  }

  final String content;
  final bool isFromUser;
  final List<String>? choices;
  final String? imageUrl;
  final DateTime? createdAt;

  static DateTime? _parseDateTime(Object? value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is String) return DateTime.tryParse(value)?.toLocal();
    return null;
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

/// Wrapper for history endpoint arrays.
class HistoryResponseModel {
  HistoryResponseModel({required this.items});

  factory HistoryResponseModel.fromJson(Map<String, dynamic> json) {
    final raw =
        json['items'] as List<dynamic>? ??
        json['messages'] as List<dynamic>? ??
        json['data'] as List<dynamic>? ??
        [];
    return HistoryResponseModel(
      items: raw
          .map((e) => HistoryItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  final List<HistoryItemModel> items;
}
