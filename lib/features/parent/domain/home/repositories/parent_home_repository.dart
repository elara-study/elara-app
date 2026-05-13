import 'package:elara/features/parent/domain/home/entities/parent_home_overview_entity.dart';

/// Loads parent dashboard data for the home tab.
abstract class ParentHomeRepository {
  Future<ParentHomeOverviewEntity> getHomeOverview();
}
