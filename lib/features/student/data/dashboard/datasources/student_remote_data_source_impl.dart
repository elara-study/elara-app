import 'package:dio/dio.dart';
import 'package:elara/core/constants/api_constants.dart';
import 'package:elara/core/error/exceptions.dart';
import 'package:elara/core/network/dio_client.dart';
import 'package:elara/features/student/data/dashboard/datasources/student_remote_data_source.dart';
import 'package:elara/features/student/data/dashboard/models/course_progress_model.dart';
import 'package:elara/features/student/data/dashboard/models/daily_goal_model.dart';
import 'package:elara/features/student/data/dashboard/models/student_group_model.dart';
import 'package:elara/features/student/data/dashboard/models/student_profile_model.dart';

class StudentRemoteDataSourceImpl implements StudentRemoteDataSource {
  final DioClient _dioClient;

  StudentRemoteDataSourceImpl({required DioClient dioClient})
      : _dioClient = dioClient;

  // Profile (still mocked — no endpoint ready yet)
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
  }

  // Continue Learning (still mocked)
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
  }

  // Daily Goals (still mocked)
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
  }

  // Groups — real API
  @override
  Future<List<StudentGroupModel>> getGroups() async {
    try {
      final response = await _dioClient.dio.get(ApiConstants.studentGroups);
      final data = response.data['data'] as Map<String, dynamic>;
      final list = data['groups'] as List<dynamic>;
      return list
          .cast<Map<String, dynamic>>()
          .map(StudentGroupModel.fromApiJson)
          .toList();
    } on DioException catch (e) {
      throw ServerException(
        e.response?.data?['message'] as String? ??
            e.message ??
            'Failed to load groups',
      );
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  // Join Group — real API
  @override
  Future<void> joinGroup(String code) async {
    try {
      await _dioClient.dio.post(
        ApiConstants.studentJoinGroup,
        data: {'joinCode': code},
      );
    } on DioException catch (e) {
      throw ServerException(
        e.response?.data?['message'] as String? ??
            e.message ??
            'Failed to join group',
      );
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
