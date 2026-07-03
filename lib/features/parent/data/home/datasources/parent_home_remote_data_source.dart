import 'package:elara/features/parent/data/home/models/parent_children_dashboard_model.dart';
import 'package:elara/features/parent/data/home/models/parent_child_progress_model.dart';
import 'package:elara/features/parent/data/home/models/parent_home_overview_model.dart';

/// Remote (or mock) API for parent home and linked children.
abstract class ParentHomeRemoteDataSource {
  Future<ParentHomeOverviewModel> fetchHomeOverview();

  Future<List<ParentChildProgressModel>> fetchLinkedChildren();

  /// Children tab — pending requests + detailed child cards (Figma `205:2260`).
  Future<ParentChildrenDashboardModel> fetchChildrenDashboard();

  Future<void> linkStudent(String studentUsername);

  Future<void> respondToRequest(String requestId, bool accept);

  Future<void> unlinkChild(String childId);
}
