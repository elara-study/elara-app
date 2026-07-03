import 'package:dio/dio.dart';
import 'package:elara/core/constants/api_constants.dart';
import 'package:elara/core/error/exceptions.dart';
import 'package:elara/core/network/dio_client.dart';
import 'package:elara/features/parent/data/home/datasources/parent_home_remote_data_source.dart';
import 'package:elara/features/parent/data/home/models/parent_child_progress_model.dart';
import 'package:elara/features/parent/data/home/models/parent_children_dashboard_model.dart';
import 'package:elara/features/parent/data/home/models/parent_home_overview_model.dart';
import 'package:elara/features/parent/data/home/models/parent_subject_group_progress_model.dart';

/// Parent home API — Home `205:2146`, Children `205:2260`.
class ParentHomeRemoteDataSourceImpl implements ParentHomeRemoteDataSource {
  final DioClient _dioClient;

  ParentHomeRemoteDataSourceImpl(this._dioClient);

  static const List<ParentChildProgressModel> _kChildren = [
    ParentChildProgressModel(
      id: 'c-1',
      displayName: 'Tyler, The Creator',
      xpPoints: 1250,
      streakDays: 7,
      currentLesson: 15,
      totalLessons: 20,
      progress: 0.75,
      gradeLabel: 'Grade 7',
      level: 12,
      subjectGroups: [
        ParentSubjectGroupProgressModel(name: 'Physics 101', progress: 0.65),
        ParentSubjectGroupProgressModel(name: 'Advanced Math', progress: 0.45),
        ParentSubjectGroupProgressModel(name: 'Biology Lab', progress: 0.80),
      ],
    ),
    ParentChildProgressModel(
      id: 'c-2',
      displayName: 'Drake',
      xpPoints: 67,
      streakDays: 1,
      currentLesson: 1,
      totalLessons: 20,
      progress: 0.05,
      gradeLabel: 'Grade 7',
      level: 12,
      subjectGroups: [
        ParentSubjectGroupProgressModel(name: 'Physics 101', progress: 0.65),
        ParentSubjectGroupProgressModel(name: 'Advanced Math', progress: 0.45),
        ParentSubjectGroupProgressModel(name: 'Biology Lab', progress: 0.80),
      ],
    ),
  ];

  @override
  Future<ParentHomeOverviewModel> fetchHomeOverview() async {
    try {
      final response = await _dioClient.dio.get(ApiConstants.parentDashboard);
      final body = response.data;
      if (body == null || body is! Map<String, dynamic>) {
        throw ServerException('Invalid server response format');
      }

      final status = body['status'] as String?;
      if (status != 'Success') {
        throw ServerException(body['message'] as String? ?? 'Failed to load dashboard overview');
      }

      final data = body['data'] as Map<String, dynamic>?;
      if (data == null) {
        throw ServerException('No data returned from server');
      }

      return ParentHomeOverviewModel.fromJson(data);
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Server connection error');
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<ParentChildProgressModel>> fetchLinkedChildren() async {
    await Future<void>.delayed(const Duration(milliseconds: 280));
    return _kChildren;
  }

  @override
  Future<ParentChildrenDashboardModel> fetchChildrenDashboard() async {
    try {
      final response = await _dioClient.dio.get(ApiConstants.parentChildrenDashboard);
      final body = response.data;
      if (body == null || body is! Map<String, dynamic>) {
        throw ServerException('Invalid server response format');
      }

      final status = body['status'] as String?;
      if (status != 'Success') {
        throw ServerException(body['message'] as String? ?? 'Failed to load children dashboard');
      }

      final data = body['data'] as Map<String, dynamic>?;
      if (data == null) {
        throw ServerException('No data returned from server');
      }

      return ParentChildrenDashboardModel.fromJson(data);
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Server connection error');
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> linkStudent(String studentUsername) async {
    try {
      final response = await _dioClient.dio.post(
        ApiConstants.parentLinkStudent,
        data: {'student_username': studentUsername},
      );
      final body = response.data;
      if (body == null || body is! Map<String, dynamic>) {
        throw ServerException('Invalid server response format');
      }
      final status = body['status'] as String?;
      if (status != 'Success') {
        throw ServerException(body['message'] as String? ?? 'Failed to send link request');
      }
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Server connection error');
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> respondToRequest(String requestId, bool accept) async {
    try {
      final response = await _dioClient.dio.put(
        ApiConstants.parentRespondToRequest(requestId),
        data: {'accept': accept},
      );
      final body = response.data;
      if (body == null || body is! Map<String, dynamic>) {
        throw ServerException('Invalid server response format');
      }
      final status = body['status'] as String?;
      if (status != 'Success') {
        throw ServerException(body['message'] as String? ?? 'Failed to respond to request');
      }
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Server connection error');
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> unlinkChild(String childId) async {
    try {
      final response = await _dioClient.dio.delete(
        ApiConstants.parentUnlinkChild(childId),
      );
      final body = response.data;
      if (body == null || body is! Map<String, dynamic>) {
        throw ServerException('Invalid server response format');
      }
      final status = body['status'] as String?;
      if (status != 'Success') {
        throw ServerException(body['message'] as String? ?? 'Failed to unlink child');
      }
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Server connection error');
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(e.toString());
    }
  }
}
