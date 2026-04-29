import 'package:elara/core/utils/logger.dart';

class ApiConstants {
  /// Compile-time value from `--dart-define-from-file=.env` or
  /// `--dart-define=API_BASE_URL=...` (see `.env.example`).
  ///
  /// Trailing slash is added if missing. Never commit your real `.env`.
  ///
  /// When unset, uses a localhost placeholder so [DioClient] can still be
  /// constructed (e.g. Rewards remote + shell tabs); network calls may fail
  /// until you define a real base URL.
  static bool _warnedMissingApiBaseUrl = false;

  static String get baseUrl {
    const raw = String.fromEnvironment('API_BASE_URL', defaultValue: '');
    if (raw.isEmpty) {
      if (!_warnedMissingApiBaseUrl) {
        _warnedMissingApiBaseUrl = true;
        AppLogger.warning(
          'API_BASE_URL is not set — using http://127.0.0.1/ for Dio. '
          'Pass --dart-define-from-file=.env for real backends.',
        );
      }
      return 'http://127.0.0.1/';
    }
    return raw.endsWith('/') ? raw : '$raw/';
  }

  static const int connectionTimeout = 30000;
  static const int receiveTimeout = 30000;

  // API Endpoints
  static const String login = 'auth/login';
  static const String register = 'auth/register';

  /// Student > Learn — Group overview (apidocs: group-overview).
  static String studentLearnGroupOverview(String groupId) =>
      'student/learn/groups/$groupId/overview';

  /// Student > Learn — Leaderboard (apidocs: leaderboard).
  static String studentLearnGroupLeaderboard(String groupId) =>
      'student/learn/groups/$groupId/leaderboard';

  /// Student > Learn — Roadmap (apidocs: roadmap).
  static String studentLearnGroupRoadmap(String groupId) =>
      'student/learn/groups/$groupId/roadmap';

  /// Student > Learn — Announcements for a group.
  static String studentLearnGroupAnnouncements(String groupId) =>
      'student/learn/groups/$groupId/announcements';

  /// Student > Rewards — Overview (GET /v1/student/rewards/overview).
  static const String studentRewardsOverview = 'v1/student/rewards/overview';

  /// Student > Rewards — Leaderboard (GET /v1/student/rewards/leaderboard).
  static const String studentRewardsLeaderboard =
      'v1/student/rewards/leaderboard';

  // ── Student chatbot (paths relative to [baseUrl] / [API_BASE_URL])

  /// GET — query `page`, `limit` (strings per OpenAPI).
  static const String chatbotConversations = 'api/v1/conversations';

  /// POST JSON `{ "message", "subject" }` — Start Conversation.
  static const String chatbotStart = 'api/v1/chat';

  /// GET history — GET Conversation History.
  static String chatbotConversation(String id) => 'api/v1/conversations/$id';

  /// POST JSON `{ "message" }` — Add Message.
  static String chatbotConversationMessages(String id) =>
      'api/v1/conversations/$id/messages';

  /// DELETE Conversation.
  static String chatbotDeleteConversation(String id) =>
      'api/v1/conversations/$id';

  /// Absolute URI under [baseUrl] for chat routes (same rules as [API_BASE_URL]).
  static Uri chatUri(String relativePath) {
    final p = relativePath.startsWith('/')
        ? relativePath.substring(1)
        : relativePath;
    final b = baseUrl.replaceAll(RegExp(r'/+$'), '');
    return Uri.parse('$b/$p');
  }

  /// Join [baseUrl] with a relative upload path (e.g. `/uploads/x.png`).
  static String resolveAssetUrl(String path) {
    if (path.startsWith('http')) return path;
    final base = baseUrl.replaceAll(RegExp(r'/+$'), '');
    final normalized = path.startsWith('/') ? path : '/$path';
    return '$base$normalized';
  }
}
