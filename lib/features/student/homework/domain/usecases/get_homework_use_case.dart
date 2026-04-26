import 'package:elara/features/student/homework/domain/entities/homework_entity.dart';
import 'package:elara/features/student/homework/domain/repositories/homework_repository.dart';

/// Fetches a single homework assignment for the current student.
///
/// Thin wrapper so the cubit depends on a use case, not a repository directly —
/// keeps the presentation layer decoupled from data details and easy to test.
class GetHomeworkUseCase {
  final HomeworkRepository _repository;

  const GetHomeworkUseCase(this._repository);

  Future<HomeworkEntity> call({
    required String homeworkId,
    String? groupId,
    String? moduleId,
  }) =>
      _repository.getHomework(
        homeworkId: homeworkId,
        groupId: groupId,
        moduleId: moduleId,
      );
}
