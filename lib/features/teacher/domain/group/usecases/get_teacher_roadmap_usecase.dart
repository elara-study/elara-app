import 'package:dartz/dartz.dart';
import 'package:elara/core/error/failures.dart';
import 'package:elara/features/teacher/domain/group/entities/teacher_roadmap_entity.dart';
import 'package:elara/features/teacher/domain/group/repositories/teacher_group_repository.dart';

class GetTeacherRoadmapUseCase {
  final TeacherGroupRepository _repository;

  GetTeacherRoadmapUseCase(this._repository);

  Future<Either<Failure, TeacherRoadmapEntity>> call(String groupId) async {
    return await _repository.getRoadmap(groupId);
  }
}
