import 'package:elara/features/parent/domain/reports/entities/parent_reports_overview_entity.dart';
import 'package:elara/features/parent/domain/reports/repositories/parent_reports_repository.dart';

class GetParentReportsUseCase {
  const GetParentReportsUseCase(this._repository);

  final ParentReportsRepository _repository;

  Future<ParentReportsOverviewEntity> call() =>
      _repository.getReportsOverview();
}
