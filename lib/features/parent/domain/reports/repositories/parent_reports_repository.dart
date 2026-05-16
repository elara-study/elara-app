import 'package:elara/features/parent/domain/reports/entities/parent_reports_overview_entity.dart';

abstract class ParentReportsRepository {
  Future<ParentReportsOverviewEntity> getReportsOverview();
}
