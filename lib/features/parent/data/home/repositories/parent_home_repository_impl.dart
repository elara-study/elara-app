import 'package:elara/features/parent/data/home/datasources/parent_home_remote_data_source.dart';
import 'package:elara/features/parent/domain/home/entities/parent_child_progress_entity.dart';
import 'package:elara/features/parent/domain/home/entities/parent_children_dashboard_entity.dart';
import 'package:elara/features/parent/domain/home/entities/parent_home_overview_entity.dart';
import 'package:elara/features/parent/domain/home/repositories/parent_home_repository.dart';

/// Maps parent home DTOs to domain entities.
class ParentHomeRepositoryImpl implements ParentHomeRepository {
  const ParentHomeRepositoryImpl(this._remote);

  final ParentHomeRemoteDataSource _remote;

  @override
  Future<ParentHomeOverviewEntity> getHomeOverview() async {
    final model = await _remote.fetchHomeOverview();
    return model.toEntity();
  }

  @override
  Future<List<ParentChildProgressEntity>> getLinkedChildren() async {
    final models = await _remote.fetchLinkedChildren();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<ParentChildrenDashboardEntity> getChildrenDashboard() async {
    final model = await _remote.fetchChildrenDashboard();
    return model.toEntity();
  }
}
