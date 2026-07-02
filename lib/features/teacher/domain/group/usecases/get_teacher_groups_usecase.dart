import 'package:dartz/dartz.dart';
import 'package:elara/core/error/failures.dart';
import 'package:elara/features/teacher/domain/group/entities/teacher_group_entity.dart';
import 'package:elara/features/teacher/domain/dashboard/repositories/teacher_home_repository.dart';

class GetTeacherGroupsUseCase {
  final TeacherHomeRepository repository;

  GetTeacherGroupsUseCase(this.repository);

  Future<Either<Failure, List<TeacherGroupEntity>>> call() {
    return repository.getGroups();
  }
}
