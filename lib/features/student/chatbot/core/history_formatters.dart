import 'package:elara/features/student/chatbot/domain/entities/chatbot_session_summary.dart';
import 'package:intl/intl.dart';

/// Short relative labels for session rows (e.g. `5m ago`, `Mar 4`).
String formatRelativeTime(DateTime time, {DateTime? reference}) {
  final now = reference ?? DateTime.now();
  var delta = now.difference(time);
  if (delta.isNegative) {
    delta = Duration.zero;
  }
  if (delta.inMinutes < 1) {
    return 'Just now';
  }
  if (delta.inHours < 1) {
    return '${delta.inMinutes}m ago';
  }
  if (delta.inHours < 24) {
    return '${delta.inHours}h ago';
  }
  if (delta.inDays < 7) {
    return '${delta.inDays}d ago';
  }
  return DateFormat.yMMMd().format(time);
}

/// Subtitle under the session title — uses API preview when present.
String previewSubtitle(ChatbotSessionSummary session) {
  final preview = session.lastMessagePreview?.trim();
  if (preview != null && preview.isNotEmpty) {
    return preview;
  }
  final title = session.title?.trim();
  if (title == null || title.isEmpty) {
    return 'Start your conversation…';
  }
  return 'Continue where you left off…';
}
