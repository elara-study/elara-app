import 'package:dartz/dartz.dart';
import 'package:elara/core/error/failures.dart';
import 'package:elara/features/teacher/group/domain/repositories/teacher_group_repository.dart';

class AddTeacherAnnouncementUseCase {
  final TeacherGroupRepository _repository;

  AddTeacherAnnouncementUseCase(this._repository);

  Future<Either<Failure, void>> call(String groupId, String title, String content) async {
    return await _repository.addAnnouncement(groupId, title, content);
  }
}
