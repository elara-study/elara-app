class ApiConstants {
  /// Compile-time value from `--dart-define-from-file=.env` or
  /// `--dart-define=API_BASE_URL=...` (see `.env.example`).
  ///
  /// Trailing slash is added if missing. Never commit your real `.env`.
  static String get baseUrl {
    const raw = String.fromEnvironment('API_BASE_URL', defaultValue: '');
    if (raw.isEmpty) {
      throw StateError(
        'API_BASE_URL is not set. Copy .env.example to .env, set '
        'API_BASE_URL there, then run:\n'
        '  flutter run --dart-define-from-file=.env',
      );
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
}
