import 'package:dartz/dartz.dart';
import 'package:elara/core/error/failures.dart';
import 'package:elara/features/teacher/domain/group/entities/teacher_student_insight_entity.dart';
import 'package:elara/features/teacher/domain/group/repositories/teacher_group_repository.dart';

class GetTeacherStudentInsightsUseCase {
  final TeacherGroupRepository _repository;

  GetTeacherStudentInsightsUseCase(this._repository);

  Future<Either<Failure, TeacherStudentInsightEntity?>> call(
    String studentId,
  ) async {
    return await _repository.getStudentInsights(studentId);
  }
}
