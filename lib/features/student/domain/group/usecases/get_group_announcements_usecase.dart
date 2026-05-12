import 'package:elara/core/network/api_result.dart';
import 'package:elara/features/student/domain/group/entities/group_announcement.dart';
import 'package:elara/features/student/domain/group/repositories/student_group_repository.dart';

/// Loads announcements for a student group.
class GetGroupAnnouncementsUseCase {
  final StudentGroupRepository _repository;

  GetGroupAnnouncementsUseCase(this._repository);

  Future<ApiResult<List<GroupAnnouncement>>> call({required String groupId}) =>
      _repository.getAnnouncements(groupId: groupId);
}
