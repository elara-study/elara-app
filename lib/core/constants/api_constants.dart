import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConstants {
  static String get baseUrl {
    final raw = dotenv.env['API_BASE_URL'] ?? '';
    return raw.endsWith('/') ? raw : '$raw/';
  }

  static const int connectionTimeout = 30000;
  static const int receiveTimeout = 30000;

  // API Endpoints
  static const String login = 'api/v1/Auth/login';
  static const String register = 'api/v1/Auth/register';
  static const String verifyEmail = 'api/v1/Auth/verify-email';

  static const String refreshToken = 'api/v1/Auth/refresh';
  static const String forgotPassword = 'api/v1/Auth/forgot-password';
  static const String resetPassword = 'api/v1/Auth/reset-password';

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

  /// Student > Profile — overview (GET when backend ready).
  static const String studentProfileOverview = 'v1/student/profile/overview';

  /// Shared settings > Profile & Account (GET when backend ready).
  static const String settingsProfileAccount = 'v1/settings/profile-account';

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
