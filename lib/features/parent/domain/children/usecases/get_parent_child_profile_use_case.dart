import 'package:elara/features/parent/domain/children/entities/parent_child_profile_entity.dart';
import 'package:elara/features/parent/domain/children/repositories/parent_children_repository.dart';

/// Usecase to fetch a detailed child profile for a parent.
class GetParentChildProfileUseCase {
  const GetParentChildProfileUseCase(this._repository);

  final ParentChildrenRepository _repository;

  Future<ParentChildProfileEntity> call(String childId) =>
      _repository.getChildProfile(childId);
}
