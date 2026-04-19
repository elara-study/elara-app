import 'package:elara/features/student/data/models/course_progress_model.dart';
import 'package:elara/features/student/data/models/daily_goal_model.dart';
import 'package:elara/features/student/data/models/student_group_model.dart';
import 'package:elara/features/student/data/models/student_profile_model.dart';

abstract class StudentRemoteDataSource {
  Future<StudentProfileModel> getStudentProfile();
  Future<CourseProgressModel> getContinueLearning();
  Future<List<DailyGoalModel>> getDailyGoals();
  Future<List<StudentGroupModel>> getGroups();
  Future<void> joinGroup(String code);
}
