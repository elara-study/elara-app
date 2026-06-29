import 'package:dartz/dartz.dart';
import 'package:elara/core/error/failures.dart';
import 'package:elara/features/teacher/group/domain/entities/teacher_student_profile_entity.dart';
import 'package:elara/features/teacher/group/domain/repositories/teacher_group_repository.dart';

class GetTeacherStudentProfileUseCase {
  final TeacherGroupRepository _repository;

  GetTeacherStudentProfileUseCase(this._repository);

  Future<Either<Failure, TeacherStudentProfileEntity>> call({
    required String groupId,
    required int studentRank,
  }) async {
    return await _repository.getStudentProfile(
      groupId: groupId,
      studentRank: studentRank,
    );
  }
}
