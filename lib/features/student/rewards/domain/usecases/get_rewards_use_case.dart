import 'package:elara/features/student/rewards/domain/repositories/rewards_repository.dart';
import 'package:injectable/injectable.dart';

/// Fetches the student's complete gamification snapshot (profile stats,
/// badges, and leaderboard) in a single call.
///
/// When the backend is ready this use case does not change — only the
/// [RewardsRepository] implementation beneath it does.
@injectable
class GetRewardsUseCase {
  final RewardsRepository _repository;

  const GetRewardsUseCase(this._repository);

  Future<RewardsData> call() => _repository.getRewards();
}
