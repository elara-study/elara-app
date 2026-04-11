import 'package:elara/core/network/api_result.dart';
import 'package:elara/features/student/group/domain/models/student_group_load_result.dart';
import 'package:elara/features/student/group/domain/repositories/student_group_repository.dart';

/// Loads group overview then leaderboard for the student Learn flow.
class LoadStudentGroupUseCase {
  final StudentGroupRepository _repository;

  LoadStudentGroupUseCase(this._repository);

  Future<ApiResult<StudentGroupLoadResult>> call({
    required String groupId,
  }) async {
    final overviewResult = await _repository.getGroupOverview(groupId: groupId);
    if (!overviewResult.isSuccess) {
      return ApiResult.failure(overviewResult.failure!);
    }

    final leaderboardResult = await _repository.getLeaderboard(
      groupId: groupId,
    );
    return leaderboardResult.fold(
      onSuccess: (entries) => ApiResult.success(
        StudentGroupLoadResult(
          overview: overviewResult.data!,
          leaderboard: entries,
        ),
      ),
      onFailure: ApiResult.failure,
    );
  }
}
