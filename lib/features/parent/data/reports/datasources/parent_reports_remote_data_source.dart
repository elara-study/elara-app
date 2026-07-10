import 'package:elara/features/parent/data/reports/models/parent_reports_overview_model.dart';

/// Remote (or mock) API for parent Reports.
abstract class ParentReportsRemoteDataSource {
  Future<ParentReportsOverviewModel> fetchReportsOverview();
}
