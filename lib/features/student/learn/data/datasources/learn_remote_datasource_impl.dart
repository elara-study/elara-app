import 'package:dio/dio.dart';
import 'package:elara/core/constants/api_endpoints.dart';
import 'package:elara/core/error/exceptions.dart';
import 'package:elara/features/student/learn/data/datasources/learn_remote_datasource.dart';
import 'package:elara/features/student/learn/data/models/student_group_model.dart';

class LearnRemoteDataSourceImpl implements LearnRemoteDataSource {
  final Dio _dio;

  LearnRemoteDataSourceImpl(this._dio);

  @override
  Future<List<StudentGroupModel>> getGroups() async {
    try {
      final response = await _dio.get<dynamic>(ApiEndpoints.studentGroups);
      final body = response.data;

      if (body is! Map<String, dynamic>) {
        throw ServerException('Invalid student groups response');
      }

      final data = body['data'];
      if (data is! Map<String, dynamic>) {
        throw ServerException('Missing groups data');
      }

      final groups = data['groups'];
      if (groups is! List) {
        throw ServerException('Missing groups list');
      }

      return groups
          .whereType<Map<String, dynamic>>()
          .map(StudentGroupModel.fromJson)
          .toList(growable: false);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.connectionTimeout) {
        throw NetworkException(
          'Cannot reach the server. Check that the backend is running and '
          'API_BASE_URL is set correctly '
          '(use 10.0.2.2 instead of localhost on Android emulator).',
        );
      }
      final data = e.response?.data;
      if (data is Map<String, dynamic>) {
        final message = data['message'] as String?;
        if (message != null && message.isNotEmpty) {
          throw ServerException(message);
        }
      }
      throw ServerException(e.message ?? 'Failed to load student groups');
    }
  }
}
