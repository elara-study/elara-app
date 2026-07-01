import 'package:dartz/dartz.dart';
import 'package:elara/core/error/failures.dart';
import 'package:elara/features/teacher/domain/entities/teacher_dashboard_entity.dart';
import 'package:elara/features/teacher/domain/repositories/teacher_home_repository.dart';

class GetTeacherDashboardUseCase {
  final TeacherHomeRepository _repository;

  GetTeacherDashboardUseCase(this._repository);

  Future<Either<Failure, TeacherDashboardEntity>> call() async {
    return await _repository.getDashboard();
  }
}
