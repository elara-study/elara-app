import 'package:elara/core/network/api_result.dart';
import 'package:elara/features/student/domain/rewards/entities/student_rewards_overview.dart';
import 'package:elara/features/student/domain/rewards/repositories/student_rewards_repository.dart';

class GetStudentRewardsOverviewUseCase {
  final StudentRewardsRepository _repository;

  GetStudentRewardsOverviewUseCase(this._repository);

  Future<ApiResult<StudentRewardsOverview>> call() => _repository.getOverview();
}
