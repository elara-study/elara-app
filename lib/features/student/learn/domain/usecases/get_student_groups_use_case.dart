import 'package:elara/features/student/learn/domain/entities/student_learn_group.dart';
import 'package:elara/features/student/learn/domain/repositories/student_learn_repository.dart';

class GetStudentGroupsUseCase {
  GetStudentGroupsUseCase(this._repository);

  final StudentLearnRepository _repository;

  Future<List<StudentLearnGroup>> call() => _repository.getGroups();
}
