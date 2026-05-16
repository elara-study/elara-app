import 'package:elara/features/parent/domain/home/entities/parent_home_overview_entity.dart';
import 'package:elara/features/parent/domain/home/repositories/parent_home_repository.dart';

class GetParentHomeUseCase {
  const GetParentHomeUseCase(this._repository);

  final ParentHomeRepository _repository;

  Future<ParentHomeOverviewEntity> call() => _repository.getHomeOverview();
}
