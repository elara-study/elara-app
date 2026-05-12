import 'package:elara/core/network/api_result.dart';
import 'package:elara/features/student/domain/rewards/entities/rewards_leaderboard_entry.dart';
import 'package:elara/features/student/domain/rewards/repositories/student_rewards_repository.dart';

class GetStudentRewardsLeaderboardUseCase {
  final StudentRewardsRepository _repository;

  GetStudentRewardsLeaderboardUseCase(this._repository);

  Future<ApiResult<List<RewardsLeaderboardEntry>>> call() =>
      _repository.getLeaderboard();
}
