import 'package:elara/features/student/data/rewards/models/badge_model.dart';
import 'package:elara/features/student/data/rewards/models/leaderboard_entry_model.dart';
import 'package:elara/features/student/data/rewards/models/rewards_profile_model.dart';

/// Abstract contract for the rewards remote data source.
///
/// Returns concrete model types so the repository can map them to entities.
/// When the backend is ready, replace [RewardsRemoteDataSourceImpl] with a
/// real implementation — this interface stays unchanged.
abstract class RewardsRemoteDataSource {
  Future<RewardsProfileModel> getRewardsProfile();
  Future<List<BadgeModel>> getBadges();
  Future<List<LeaderboardEntryModel>> getLeaderboard();
}
