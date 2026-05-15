import 'package:elara/features/parent/domain/home/entities/parent_children_dashboard_entity.dart';
import 'package:elara/features/parent/domain/home/repositories/parent_home_repository.dart';

class GetParentChildrenDashboardUseCase {
  const GetParentChildrenDashboardUseCase(this._repository);

  final ParentHomeRepository _repository;

  Future<ParentChildrenDashboardEntity> call() =>
      _repository.getChildrenDashboard();
}
