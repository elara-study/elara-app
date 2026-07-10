import 'package:elara/features/parent/domain/home/entities/parent_child_progress_entity.dart';
import 'package:elara/features/parent/domain/home/entities/parent_children_dashboard_entity.dart';
import 'package:elara/features/parent/domain/home/entities/parent_home_overview_entity.dart';

/// Parent home / linked-children access (Home + Children tabs).
abstract class ParentHomeRepository {
  Future<ParentHomeOverviewEntity> getHomeOverview();

  Future<List<ParentChildProgressEntity>> getLinkedChildren();

  /// Children tab — Figma `205:2260`.
  Future<ParentChildrenDashboardEntity> getChildrenDashboard();

  Future<void> linkStudent(String studentUsername);

  Future<String> respondToRequest(String requestId, bool accept);

  Future<void> unlinkChild(String childId);
}
