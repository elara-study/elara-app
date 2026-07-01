import 'package:dartz/dartz.dart';
import 'package:elara/core/error/failures.dart';
import 'package:elara/features/teacher/domain/dashboard/repositories/teacher_home_repository.dart';

class CreateTeacherRoadmapUseCase {
  final TeacherHomeRepository _repository;

  CreateTeacherRoadmapUseCase(this._repository);

  Future<Either<Failure, void>> call({
    required String title,
    required String subject,
    required String grade,
  }) async {
    return await _repository.createRoadmap(
      title: title,
      subject: subject,
      grade: grade,
    );
  }
}
