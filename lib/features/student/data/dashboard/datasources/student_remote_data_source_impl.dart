import 'package:elara/core/constants/api_constants.dart';
import 'package:elara/core/network/dio_client.dart';
import 'package:elara/core/utils/logger.dart';
import 'package:elara/features/student/data/dashboard/datasources/student_remote_data_source.dart';
import 'package:elara/features/student/data/dashboard/models/course_progress_model.dart';
import 'package:elara/features/student/data/dashboard/models/daily_goal_model.dart';
import 'package:elara/features/student/data/dashboard/models/student_group_model.dart';
import 'package:elara/features/student/data/dashboard/models/student_profile_model.dart';

/// Remote implementation — [getGroups] is wired to the real API.
/// Other methods remain mocked until their endpoints are available.
class StudentRemoteDataSourceImpl implements StudentRemoteDataSource {
  final DioClient _dioClient;

  StudentRemoteDataSourceImpl(this._dioClient);

  @override
  Future<StudentProfileModel> getStudentProfile() async {
    await Future.delayed(const Duration(milliseconds: 600));
    return const StudentProfileModel(
      id: 'student-001',
      fullName: 'Tyler Johnson',
      firstName: 'Tyler',
      points: 1250,
      notificationCount: 7,
    );
    // ── REAL ────────────────────────────────────────────────────────────────
    // final response = await _dioClient.dio.get('student/profile');
    // return StudentProfileModel.fromJson(response.data);
  }

  @override
  Future<CourseProgressModel> getContinueLearning() async {
    await Future.delayed(const Duration(milliseconds: 600));
    return const CourseProgressModel(
      courseName: 'Algebra Basics',
      lessonLabel: 'Lesson 5 of 8',
      currentLesson: 5,
      totalLessons: 8,
      progressPercent: 0.62,
      lessonId: 'lesson-alg-005',
    );
    // ── REAL ────────────────────────────────────────────────────────────────
    // final response = await _dioClient.dio.get('student/continue-learning');
    // return CourseProgressModel.fromJson(response.data);
  }

  @override
  Future<List<DailyGoalModel>> getDailyGoals() async {
    await Future.delayed(const Duration(milliseconds: 600));
    return const [
      DailyGoalModel(
        id: 'goal-001',
        label: 'Complete 3 lessons',
        iconKey: 'book',
        xpReward: 50,
        isCompleted: false,
      ),
      DailyGoalModel(
        id: 'goal-002',
        label: 'Score 80% on a quiz',
        iconKey: 'quiz',
        xpReward: 30,
        isCompleted: true,
      ),
      DailyGoalModel(
        id: 'goal-003',
        label: 'Practice for 15 mins',
        iconKey: 'timer',
        xpReward: 25,
        isCompleted: false,
      ),
    ];
    // ── REAL ────────────────────────────────────────────────────────────────
    // final response = await _dioClient.dio.get('student/daily-goals');
    // return (response.data as List).map(DailyGoalModel.fromJson).toList();
  }

  @override
  Future<List<StudentGroupModel>> getGroups() async {
    AppLogger.log('StudentRemoteDataSourceImpl: fetching groups');
    final response = await _dioClient.dio.get(ApiConstants.studentGroups);
    final data = response.data as Map<String, dynamic>;
    final groupsJson = data['data']['groups'] as List<dynamic>;
    return groupsJson
        .map((e) => StudentGroupModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> joinGroup(String code) async {
    await Future.delayed(const Duration(milliseconds: 800));
    // Simulate invalid code validation
    if (code.trim().isEmpty || code.trim().length < 4) {
      throw Exception('Invalid group code. Please check and try again.');
    }
    // ── REAL ────────────────────────────────────────────────────────────────
    // await _dioClient.dio.post('student/groups/join', data: {'code': code});
  }
}
