import 'package:dartz/dartz.dart';
import 'package:elara/core/error/failures.dart';
import 'package:elara/features/teacher/domain/group/repositories/teacher_group_repository.dart';

class DeleteTeacherGroupUseCase {
  final TeacherGroupRepository _repository;

  DeleteTeacherGroupUseCase(this._repository);

  Future<Either<Failure, void>> call(String groupId) {
    return _repository.deleteGroup(groupId);
  }
}
