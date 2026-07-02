import 'package:elara/core/network/api_result.dart';
import 'package:elara/features/teacher/domain/homework/entities/teacher_student_submission_detail_entity.dart';
import 'package:elara/features/teacher/domain/homework/repositories/i_teacher_homework_repository.dart';

class GetTeacherStudentSubmissionUseCase {
  final ITeacherHomeworkRepository _repository;

  const GetTeacherStudentSubmissionUseCase(this._repository);

  Future<ApiResult<TeacherStudentSubmissionDetailEntity>> call({
    required String moduleId,
    required String studentId,
    required String groupId,
  }) => _repository.getStudentSubmission(
        moduleId: moduleId,
        studentId: studentId,
        groupId: groupId,
      );
}
