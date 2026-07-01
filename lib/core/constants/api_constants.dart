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
  static const String authMe = 'api/v1/Auth/me';

  static const String refreshToken = 'api/v1/Auth/refresh';
  static const String forgotPassword = 'api/v1/Auth/forgot-password';
  static const String resetPassword = 'api/v1/Auth/reset-password';

  // OAuth
  static const String googleSignIn = 'api/v1/oauth/google';
  static const String completeRegistration =
      'api/v1/oauth/complete-registration';

  // Teacher
  static const String teacherHome = 'api/v1/teacher/home';
  static const String teacherGroups = 'api/v1/teacher/groups';
  static const String teacherRoadmaps = 'api/v1/teacher/roadmaps';
  static String teacherRoadmapInfo(String id) => 'api/v1/teacher/roadmaps/$id';
  static String teacherModuleHomework(String moduleId) =>
      'api/v1/modules/$moduleId/homework';
  static String teacherModuleHomeworkProblems(String moduleId) =>
      'api/v1/teacher/modules/$moduleId/homework/problems';

  static String teacherGroupInfo(String id) => 'api/v1/teacher/groups/$id';
  static String teacherGroupStudents(String id) =>
      'api/v1/teacher/groups/$id/students';
  static String teacherGroupAnnouncements(String id) =>
      'api/v1/teacher/groups/$id/announcements';
  static String teacherGroupDeleteAnnouncement(
    String groupId,
    String announcementId,
  ) => 'api/v1/teacher/groups/$groupId/announcements/$announcementId';
  static String teacherGroupRoadmap(String groupId) =>
      'api/v1/teacher/groups/$groupId/roadmap';
  static String teacherStudentInfo(String studentId) =>
      'api/v1/teacher/students/$studentId';

  /// Student > Learn — All groups the student is enrolled in.
  static const String studentGroups = 'api/v1/student/groups';

  /// Student > Learn — Group overview (GET /api/v1/student/groups/{id}).
  static String studentLearnGroupOverview(String groupId) =>
      'api/v1/student/groups/$groupId';

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

  // ── Quiz ──────────────────────────────────────────────────────────────────

  /// POST — Generate a new quiz session.
  static const String generateQuiz = 'api/v1/quiz/generate';

  /// GET — Fetch a hint for a specific question in a session.
  static String quizHint(int sessionId, int questionNumber) =>
      'api/v1/quiz/sessions/$sessionId/questions/$questionNumber/hint';

  /// POST — Submit a single answer for a question in a session.
  static String submitAnswer(int sessionId) =>
      'api/v1/quiz/sessions/$sessionId/answers';

  /// POST — Mark a quiz session as complete and retrieve results.
  static String completeQuiz(int sessionId) =>
      'api/v1/quiz/sessions/$sessionId/complete';

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
