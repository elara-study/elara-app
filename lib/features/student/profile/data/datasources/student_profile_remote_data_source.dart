import 'package:elara/features/student/profile/data/models/student_profile_overview_model.dart';

abstract class StudentProfileRemoteDataSource {
  Future<StudentProfileOverviewModel> getProfileOverview();
}
