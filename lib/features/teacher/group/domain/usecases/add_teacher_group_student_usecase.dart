import 'package:dartz/dartz.dart';
import 'package:elara/core/error/failures.dart';
import 'package:elara/features/teacher/group/domain/repositories/teacher_group_repository.dart';

class AddTeacherGroupStudentUseCase {
  final TeacherGroupRepository _repository;

  AddTeacherGroupStudentUseCase(this._repository);

  Future<Either<Failure, void>> call(String groupId, String username) async {
    return await _repository.addStudent(groupId: groupId, username: username);
  }
}
