import 'package:elara/features/student/rewards/domain/entities/badge_entity.dart';
import 'package:elara/features/student/rewards/domain/entities/leaderboard_entry_entity.dart';
import 'package:elara/features/student/rewards/domain/entities/rewards_profile_entity.dart';

/// Bundles all data returned by a single [RewardsRepository.getRewards] call.
///
/// Using a wrapper keeps the repository API to one method, which maps
/// directly to one future backend endpoint (e.g. GET /student/rewards).
class RewardsData {
  final RewardsProfileEntity profile;
  final List<BadgeEntity> badges;
  final List<LeaderboardEntryEntity> leaderboard;

  const RewardsData({
    required this.profile,
    required this.badges,
    required this.leaderboard,
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
}
