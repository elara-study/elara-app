import 'package:dartz/dartz.dart';
import 'package:elara/core/error/failures.dart';
import 'package:elara/features/teacher/domain/group/repositories/teacher_group_repository.dart';

class DeleteTeacherAnnouncementUseCase {
  final TeacherGroupRepository _repository;

  DeleteTeacherAnnouncementUseCase(this._repository);

  Future<Either<Failure, void>> call(
    String groupId,
    String announcementId,
  ) async {
    return await _repository.deleteAnnouncement(groupId, announcementId);
  }
}
