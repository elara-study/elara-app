import 'package:dartz/dartz.dart';
import 'package:elara/core/error/failures.dart';
import 'package:elara/features/teacher/domain/group/entities/teacher_roadmap_entity.dart';
import 'package:elara/features/teacher/domain/dashboard/repositories/teacher_home_repository.dart';

class GetTeacherRoadmapDetailsUseCase {
  final TeacherHomeRepository _repository;

  GetTeacherRoadmapDetailsUseCase(this._repository);

  Future<Either<Failure, TeacherRoadmapEntity>> call(String id) async {
    return await _repository.getRoadmapDetails(id);
  }
}
