import 'package:elara/features/parent/domain/children/entities/parent_child_profile_entity.dart';

/// Repository interface for parent-linked children details.
abstract class ParentChildrenRepository {
  Future<ParentChildProfileEntity> getChildProfile(String childId);
}
