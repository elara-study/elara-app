import 'package:elara/features/student/rewards/data/datasources/rewards_remote_data_source.dart';
import 'package:elara/features/student/rewards/domain/repositories/rewards_repository.dart';

/// Concrete implementation of [RewardsRepository].
///
/// Delegates to [RewardsRemoteDataSource] and maps models to domain entities
/// via polymorphism (models extend entities, so no explicit mapping needed).
/// All three network calls are fired concurrently to minimize latency.
class RewardsRepositoryImpl implements RewardsRepository {
  final RewardsRemoteDataSource _dataSource;

  const RewardsRepositoryImpl(this._dataSource);

  @override
  Future<RewardsData> getRewards() async {
    // Launch concurrently, then collect — equivalent to Promise.all.
    final profileFuture = _dataSource.getRewardsProfile();
    final badgesFuture = _dataSource.getBadges();
    final leaderboardFuture = _dataSource.getLeaderboard();

    return RewardsData(
      profile: await profileFuture,
      badges: await badgesFuture,
      leaderboard: await leaderboardFuture,
    );
  }
}
