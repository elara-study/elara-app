import 'package:dartz/dartz.dart';
import 'package:elara/core/error/failures.dart';
import 'package:elara/features/student/domain/group/entities/group_announcement.dart';
import 'package:elara/features/teacher/group/domain/repositories/teacher_group_repository.dart';

class GetTeacherAnnouncementsUseCase {
  final TeacherGroupRepository _repository;

  GetTeacherAnnouncementsUseCase(this._repository);

  Future<Either<Failure, List<GroupAnnouncement>>> call(String groupId) async {
    return await _repository.getAnnouncements(groupId);
  }
}
