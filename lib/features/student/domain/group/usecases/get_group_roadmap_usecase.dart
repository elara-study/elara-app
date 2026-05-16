import 'package:elara/core/network/api_result.dart';
import 'package:elara/features/student/domain/group/entities/group_roadmap.dart';
import 'package:elara/features/student/domain/group/repositories/student_group_repository.dart';

/// Loads the learning path / roadmap for a student group.
class GetGroupRoadmapUseCase {
  final StudentGroupRepository _repository;

  GetGroupRoadmapUseCase(this._repository);

  Future<ApiResult<GroupRoadmap>> call({required String groupId}) =>
      _repository.getRoadmap(groupId: groupId);
}
