import 'package:dartz/dartz.dart';
import 'package:elara/core/error/failures.dart';
import 'package:elara/features/teacher/domain/group/entities/teacher_group_detail_entity.dart';
import 'package:elara/features/teacher/domain/group/repositories/teacher_group_repository.dart';

class GetTeacherGroupDetailUseCase {
  final TeacherGroupRepository _repository;

  GetTeacherGroupDetailUseCase(this._repository);

  Future<Either<Failure, TeacherGroupDetailEntity>> call(String groupId) async {
    return await _repository.getGroupDetail(groupId);
  }
}
