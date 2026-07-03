import 'package:dio/dio.dart';
import 'package:elara/core/constants/api_constants.dart';
import 'package:elara/core/error/exceptions.dart';
import 'package:elara/core/network/dio_client.dart';
import 'package:elara/features/parent/data/children/datasources/parent_children_remote_data_source.dart';
import 'package:elara/features/parent/data/children/models/parent_child_insight_model.dart';
import 'package:elara/features/parent/data/children/models/parent_child_profile_model.dart';
import 'package:elara/features/parent/data/children/models/parent_homework_model.dart';
import 'package:elara/features/parent/data/home/models/parent_child_progress_model.dart';
import 'package:elara/features/parent/data/home/models/parent_children_dashboard_model.dart';
import 'package:elara/features/parent/domain/children/entities/parent_child_profile_entity.dart';
import 'package:elara/features/parent/domain/children/entities/parent_homework_card_entity.dart';
import 'package:elara/features/teacher/domain/group/entities/teacher_student_insight_entity.dart';

/// Concrete implementation of ParentChildrenRemoteDataSource using Dio.
class ParentChildrenRemoteDataSourceImpl implements ParentChildrenRemoteDataSource {
  const ParentChildrenRemoteDataSourceImpl(this._dioClient);

  final DioClient _dioClient;

  @override
  Future<ParentChildProfileEntity> fetchChildProfile(String childId) async {
    try {
      // 1. Fetch children dashboard list to find the child's basic progress/stats
      final dashboardResponse = await _dioClient.dio.get(ApiConstants.parentChildrenDashboard);
      final dashboardData = dashboardResponse.data;
      if (dashboardData == null || dashboardData is! Map<String, dynamic>) {
        throw ServerException('Invalid children response data');
      }
      final dashboardPayload = dashboardData['data'] as Map<String, dynamic>?;
      final dashboardModel = ParentChildrenDashboardModel.fromJson(dashboardPayload ?? {});
      final childrenList = dashboardModel.children;

      final matchingChild = childrenList.firstWhere(
        (c) => c.id == childId,
        orElse: () => ParentChildProgressModel(
          id: childId,
          displayName: '',
          xpPoints: 0,
          streakDays: 0,
          currentLesson: 0,
          totalLessons: 0,
          progress: 0.0,
        ),
      );

      // 2. Fetch insights
      final insights = await fetchChildInsights(childId);
      final latestInsight = insights.isNotEmpty ? insights.first : null;

      // 3. Fetch homeworks
      final homeworks = await fetchChildHomeworks(childId);

      return ParentChildProfileModel(
        child: matchingChild.toEntity(),
        attendanceLabel: '100%',
        insight: latestInsight,
        homeworks: homeworks,
      );
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Network error');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<ParentHomeworkCardEntity>> fetchChildHomeworks(String childId) async {
    try {
      final response = await _dioClient.dio.get(ApiConstants.parentChildHomeworks(childId));
      final data = response.data;
      if (data == null) {
        throw ServerException('Invalid response data');
      }
      final payload = data['data'] as List?;
      if (payload == null) {
        return const [];
      }
      return payload
          .whereType<Map<String, dynamic>>()
          .map((h) => ParentHomeworkCardEntity.fromHomework(ParentHomeworkModel.fromJson(h)))
          .toList();
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Network error');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<TeacherStudentInsightEntity>> fetchChildInsights(String childId) async {
    try {
      final response = await _dioClient.dio.get(ApiConstants.parentChildInsights(childId));
      final data = response.data;
      if (data == null || data is! Map<String, dynamic>) {
        throw ServerException('Invalid response data');
      }
      final payload = data['data'] as Map<String, dynamic>?;
      if (payload == null) {
        return const [];
      }
      final reports = payload['reports'] as List?;
      if (reports == null) {
        return const [];
      }
      return reports
          .whereType<Map<String, dynamic>>()
          .map(ParentChildInsightModel.fromJson)
          .toList();
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Network error');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
