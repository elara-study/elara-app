import 'package:elara/features/parent/data/reports/datasources/parent_reports_remote_data_source.dart';
import 'package:elara/features/parent/domain/reports/entities/parent_reports_overview_entity.dart';
import 'package:elara/features/parent/domain/reports/repositories/parent_reports_repository.dart';

/// Maps parent Reports DTOs to domain entities.
class ParentReportsRepositoryImpl implements ParentReportsRepository {
  const ParentReportsRepositoryImpl(this._remote);

  final ParentReportsRemoteDataSource _remote;

  @override
  Future<ParentReportsOverviewEntity> getReportsOverview() async {
    final model = await _remote.fetchReportsOverview();
    return model.toEntity();
  }
}
