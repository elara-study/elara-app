import 'package:elara/features/parent/domain/children/entities/parent_homework_card_entity.dart';
import 'package:elara/features/parent/domain/children/repositories/parent_children_repository.dart';

/// Fetches all homework assignments for a specific child.
class GetParentChildHomeworksUseCase {
  const GetParentChildHomeworksUseCase(this._repository);

  final ParentChildrenRepository _repository;

  Future<List<ParentHomeworkCardEntity>> call(String childId) =>
      _repository.getChildHomeworks(childId);
}
