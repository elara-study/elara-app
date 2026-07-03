import 'package:elara/features/parent/domain/home/repositories/parent_home_repository.dart';

class LinkStudentUseCase {
  const LinkStudentUseCase(this._repository);

  final ParentHomeRepository _repository;

  Future<void> call(String studentUsername) =>
      _repository.linkStudent(studentUsername);
}
