import 'package:elara/features/parent/domain/home/repositories/parent_home_repository.dart';

class UnlinkChildUseCase {
  const UnlinkChildUseCase(this._repository);

  final ParentHomeRepository _repository;

  Future<void> call(String childId) => _repository.unlinkChild(childId);
}
