import 'package:elara/core/network/api_result.dart';
import 'package:elara/features/student/domain/rewards/entities/rewards_leaderboard_entry.dart';
import 'package:elara/features/student/domain/rewards/entities/student_rewards_overview.dart';

abstract class StudentRewardsRepository {
  Future<ApiResult<StudentRewardsOverview>> getOverview();

  Future<ApiResult<List<RewardsLeaderboardEntry>>> getLeaderboard();
}
