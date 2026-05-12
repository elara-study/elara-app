import 'package:elara/features/student/data/profile/models/student_profile_overview_model.dart';

abstract class StudentProfileRemoteDataSource {
  Future<StudentProfileOverviewModel> getProfileOverview();
}
