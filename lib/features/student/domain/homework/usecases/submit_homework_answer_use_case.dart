import 'package:elara/features/student/domain/homework/repositories/homework_repository.dart';

/// Submits a student's answer for a specific homework problem.
class SubmitHomeworkAnswerUseCase {
  final HomeworkRepository _repository;

  const SubmitHomeworkAnswerUseCase(this._repository);

  Future<void> call({
    required String moduleId,
    required String problemId,
    required String groupId,
    required String answer,
  }) => _repository.submitHomeworkAnswer(
    moduleId: moduleId,
    problemId: problemId,
    groupId: groupId,
    answer: answer,
  );
}
