import 'package:elara/features/student/data/rewards/models/badge_model.dart';
import 'package:elara/features/student/data/rewards/models/leaderboard_entry_model.dart';
import 'package:elara/features/student/data/rewards/models/rewards_profile_model.dart';

/// Abstract contract for the rewards remote data source.
///
/// Returns concrete model types so the repository can map them to entities.
abstract class RewardsRemoteDataSource {
  /// Fetches the live rewards summary from `GET /api/v1/Rewards/summary`.
  Future<RewardsProfileModel> getRewardsSummary();

  Future<RewardsProfileModel> getRewardsProfile();
  Future<List<BadgeModel>> getBadges();

  /// Fetches the leaderboard from `GET /api/v1/Rewards/leaderboard`.
  /// Defaults to allTime / page 1 / 10 entries per page.
  Future<List<LeaderboardEntryModel>> getLeaderboard({
    String period,
    int page,
    int pageSize,
  });
}
