import 'package:dartz/dartz.dart';
import 'package:elara/core/error/failures.dart';
import 'package:elara/features/teacher/domain/group/repositories/teacher_group_repository.dart';

class DeleteTeacherRoadmapUseCase {
  final TeacherGroupRepository _repository;

  DeleteTeacherRoadmapUseCase(this._repository);

  Future<Either<Failure, void>> call(String roadmapId) {
    return _repository.deleteRoadmap(roadmapId);
  }
}
