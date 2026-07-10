import 'package:elara/features/student/domain/profile/entities/student_profile_overview_entity.dart';

/// Contract for student profile tab data.
abstract class StudentProfileRepository {
  Future<StudentProfileOverviewEntity> getProfileOverview();
}
