import 'package:dio/dio.dart';
import 'package:elara/core/constants/api_constants.dart';
import 'package:elara/core/error/exceptions.dart';
import 'package:elara/core/network/dio_client.dart';
import 'package:elara/features/parent/data/home/datasources/parent_home_remote_data_source.dart';
import 'package:elara/features/parent/data/home/models/parent_child_progress_model.dart';
import 'package:elara/features/parent/data/home/models/parent_children_dashboard_model.dart';
import 'package:elara/features/parent/data/home/models/parent_home_overview_model.dart';

/// Parent home API — Home `205:2146`, Children `205:2260`.
class ParentHomeRemoteDataSourceImpl implements ParentHomeRemoteDataSource {
  final DioClient _dioClient;

  ParentHomeRemoteDataSourceImpl(this._dioClient);

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
    final dashboard = await fetchChildrenDashboard();
    return dashboard.children;
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
        data: {'child_username': studentUsername},
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
  Future<String> respondToRequest(String requestId, bool accept) async {
    try {
      final response = await _dioClient.dio.put(
        ApiConstants.parentRespondToRequest(requestId),
        data: {'action': accept ? 'accept' : 'decline'},
      );
      final body = response.data;
      if (body == null || body is! Map<String, dynamic>) {
        throw ServerException('Invalid server response format');
      }
      final status = body['status'] as String?;
      if (status != 'Success') {
        throw ServerException(body['message'] as String? ?? 'Failed to respond to request');
      }
      return body['message'] as String? ?? (accept ? 'Request accepted.' : 'Request declined.');
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
