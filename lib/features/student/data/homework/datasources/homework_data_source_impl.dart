import 'package:dio/dio.dart';
import 'package:elara/core/error/exceptions.dart';
import 'package:elara/core/network/dio_client.dart';
import 'package:elara/features/student/data/homework/datasources/homework_data_source.dart';
import 'package:elara/features/student/data/homework/models/homework_model.dart';

/// Concrete implementation of [HomeworkDataSource] that fetches and submits
/// student homework data from the real API using [DioClient].
class HomeworkDataSourceImpl implements HomeworkDataSource {
  final DioClient _dioClient;

  HomeworkDataSourceImpl({required DioClient dioClient}) : _dioClient = dioClient;

  @override
  Future<HomeworkModel> getHomework({
    required String homeworkId,
    String? groupId,
    String? moduleId,
  }) async {
    if (moduleId == null || moduleId.isEmpty) {
      throw ServerException('Module ID is required to fetch homework');
    }

    try {
      final response = await _dioClient.dio.get(
        'api/v1/modules/$moduleId/homework',
      );
      return HomeworkModel.fromApiJson(
        response.data as Map<String, dynamic>,
        moduleId,
      );
    } on DioException catch (e) {
      throw ServerException(
        e.response?.data?['message'] as String? ??
            e.message ??
            'Failed to load homework',
      );
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> submitHomeworkAnswer({
    required String moduleId,
    required String problemId,
    required String groupId,
    required String answer,
  }) async {
    try {
      await _dioClient.dio.post(
        'api/v1/modules/$moduleId/homework/problems/$problemId',
        data: {
          'groupId': groupId,
          'answer': answer,
        },
      );
    } on DioException catch (e) {
      throw ServerException(
        e.response?.data?['message'] as String? ??
            e.message ??
            'Failed to submit homework answer',
      );
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
