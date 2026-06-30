import 'package:dartz/dartz.dart';
import 'package:elara/core/error/failures.dart';
import 'package:elara/features/teacher/domain/repositories/teacher_home_repository.dart';

class CreateTeacherGroupUseCase {
  final TeacherHomeRepository _repository;

  CreateTeacherGroupUseCase(this._repository);

  Future<Either<Failure, void>> call({
    required String title,
    required String subject,
    required String grade,
    required String roadmapName,
  }) async {
    return await _repository.createGroup(
      title: title,
      subject: subject,
      grade: grade,
      roadmapName: roadmapName,
    );
  }
}
