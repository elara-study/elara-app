import 'package:elara/features/parent/domain/children/entities/parent_child_profile_entity.dart';

/// Data source interface for parent children detail queries.
abstract class ParentChildrenRemoteDataSource {
  Future<ParentChildProfileEntity> fetchChildProfile(String childId);
}
