import 'dart:convert';

/// One row returned by GET session history.
class HistoryItemModel {
  HistoryItemModel({
    required this.content,
    required this.isFromUser,
    this.choices,
    this.imageUrl,
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
    );
  }

  static bool _inferIsFromUser(Map<String, dynamic> json) {
    final direct = json['isFromUser'] as bool? ?? json['is_from_user'] as bool?;
    if (direct != null) return direct;
    final role = (json['role'] ?? json['sender'] ?? json['from'])
        ?.toString()
        .toLowerCase();
    if (role == 'assistant' || role == 'bot') return false;
    if (role == 'user' || role == 'student') return true;
    return false;
  }

  final String content;
  final bool isFromUser;
  final List<String>? choices;
  final String? imageUrl;

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

/// Wrapper `{ "items": [ ... ] }` from history endpoint.
class HistoryResponseModel {
  HistoryResponseModel({required this.items});

  factory HistoryResponseModel.fromJson(Map<String, dynamic> json) {
    final raw = json['items'] as List<dynamic>? ?? [];
    return HistoryResponseModel(
      items: raw
          .map((e) => HistoryItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  final List<HistoryItemModel> items;
}
