import 'package:dartz/dartz.dart';
import 'package:elara/core/error/failures.dart';
import 'package:elara/features/teacher/domain/entities/teacher_group_entity.dart';
import 'package:elara/features/teacher/domain/repositories/teacher_home_repository.dart';

class GetTeacherRoadmapsUseCase {
  final TeacherHomeRepository _repository;

  GetTeacherRoadmapsUseCase(this._repository);

  Future<Either<Failure, List<TeacherGroupEntity>>> call() async {
    return await _repository.getRoadmaps();
  }
}
