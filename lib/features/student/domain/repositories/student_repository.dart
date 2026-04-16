import 'package:elara/features/student/domain/entities/course_progress_entity.dart';
import 'package:elara/features/student/domain/entities/daily_goal_entity.dart';
import 'package:elara/features/student/domain/entities/student_group_entity.dart';
import 'package:elara/features/student/domain/entities/student_profile_entity.dart';

/// Abstract contract for all student-related data operations.
///
/// The data layer provides a concrete implementation ([StudentRepositoryImpl]).
/// When the backend is ready, only the data source implementation needs to change —
/// this contract and all cubits remain untouched.
abstract class StudentRepository {
  /// Fetch the authenticated student's profile (name, points, notifications).
  Future<StudentProfileEntity> getStudentProfile();

  /// Fetch the course the student should continue from (Continue Learning card).
  Future<CourseProgressEntity> getContinueLearning();

  /// Fetch today's daily goals and their completion status.
  Future<List<DailyGoalEntity>> getDailyGoals();

  /// Fetch all groups the student is currently enrolled in.
  Future<List<StudentGroupEntity>> getGroups();

  /// Enroll the student in a group using a teacher-provided [code].
  /// Throws [ServerException] if the code is invalid or already used.
  Future<void> joinGroup(String code);
}
