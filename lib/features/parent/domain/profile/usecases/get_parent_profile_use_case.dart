import 'package:elara/features/parent/domain/profile/entities/parent_profile_entity.dart';
import 'package:elara/features/parent/domain/profile/repositories/parent_profile_repository.dart';

class GetParentProfileUseCase {
  const GetParentProfileUseCase(this._repository);

  final ParentProfileRepository _repository;

  Future<ParentProfileEntity> call() async {
    return _repository.getParentProfile();
  }
}
