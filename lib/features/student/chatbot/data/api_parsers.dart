import 'package:elara/features/student/chatbot/data/models/history_models.dart';

/// OpenAPI leaves response `properties: {}` — normalize common envelope shapes.
List<Map<String, dynamic>> decodeObjectList(dynamic root) {
  if (root == null) return [];
  if (root is List) {
    return root
        .whereType<Map>()
        .map((e) => Map<String, dynamic>.from(e))
        .toList();
  }
  if (root is Map<String, dynamic>) {
    for (final key in <String>[
      'data',
      'items',
      'conversations',
      'results',
      'rows',
    ]) {
      final v = root[key];
      if (v is List) return decodeObjectList(v);
    }
    final nested = root['data'];
    if (nested is Map<String, dynamic>) {
      return decodeObjectList(nested);
    }
  }
  return [];
}

/// Conversation GET — extract message rows.
List<HistoryItemModel> decodeConversationHistory(dynamic root) {
  if (root == null) return [];
  if (root is List) {
    return root
        .whereType<Map>()
        .map((e) => HistoryItemModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }
  if (root is Map<String, dynamic>) {
    final nestedConv = root['conversation'];
    if (nestedConv is Map<String, dynamic>) {
      final inner = decodeConversationHistory(nestedConv);
      if (inner.isNotEmpty) return inner;
    }
    for (final key in <String>['messages', 'items', 'history']) {
      final v = root[key];
      final decoded = decodeConversationHistory(v);
      if (decoded.isNotEmpty) return decoded;
    }
    final data = root['data'];
    if (data is Map<String, dynamic>) {
      return decodeConversationHistory(data);
    }
  }
  return [];
}
