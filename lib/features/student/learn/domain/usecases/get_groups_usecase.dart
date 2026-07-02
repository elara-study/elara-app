import 'package:elara/core/network/api_result.dart';
import 'package:elara/features/student/learn/domain/entities/student_group.dart';
import 'package:elara/features/student/learn/domain/repositories/learn_repository.dart';

class GetGroupsUseCase {
  final LearnRepository _repository;

  GetGroupsUseCase(this._repository);

  Future<ApiResult<List<StudentGroup>>> call() => _repository.getGroups();
}
