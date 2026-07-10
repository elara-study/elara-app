import 'package:elara/features/parent/domain/profile/entities/parent_profile_entity.dart';

abstract class ParentProfileRepository {
  Future<ParentProfileEntity> getParentProfile();
}
