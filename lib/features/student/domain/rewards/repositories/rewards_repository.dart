import 'package:elara/features/student/domain/dashboard/entities/daily_goal_entity.dart';
import 'package:elara/features/student/domain/rewards/entities/badge_entity.dart';
import 'package:elara/features/student/domain/rewards/entities/leaderboard_entry_entity.dart';
import 'package:elara/features/student/domain/rewards/entities/rewards_profile_entity.dart';

/// Bundles all data returned by a single [RewardsRepository.getRewards] call.
///
/// Using a wrapper keeps the repository API to one method, which maps
/// directly to one future backend endpoint (e.g. GET /student/rewards).
class RewardsData {
  final RewardsProfileEntity profile;
  final List<BadgeEntity> badges;
  final List<LeaderboardEntryEntity> leaderboard;
  final List<DailyGoalEntity> dailyGoals;

  const RewardsData({
    required this.profile,
    required this.badges,
    required this.leaderboard,
    required this.dailyGoals,
  });
}

/// Abstract contract for all rewards/gamification data.
///
/// The data layer provides [RewardsRepositoryImpl].
/// When the backend is ready, only the data source implementation changes —
/// this contract, use case, and cubit remain untouched.
abstract class RewardsRepository {
  /// Fetch the student's full gamification snapshot:
  /// profile stats, badge list, and leaderboard entries.
  Future<RewardsData> getRewards();

  /// Fetches daily goals.
  Future<List<DailyGoalEntity>> getDailyGoals();

  /// Updates student profile stats, daily goals, and badge progress.
  /// Returns a list of badges that were unlocked in this update.
  Future<List<BadgeEntity>> updateStats({
    required int xpGained,
    required double quizAccuracy,
    String? subject,
    int lessonCompletedCount = 0,
    int practiceSeconds = 0,
  });
}
