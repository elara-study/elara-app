import 'package:dio/dio.dart';
import 'package:elara/core/constants/api_constants.dart';
import 'package:elara/core/error/exceptions.dart';
import 'package:elara/core/network/dio_client.dart';
import 'package:elara/features/parent/data/children/datasources/parent_children_remote_data_source.dart';
import 'package:elara/features/parent/data/children/models/parent_child_insight_model.dart';
import 'package:elara/features/parent/data/children/models/parent_child_profile_model.dart';
import 'package:elara/features/parent/data/children/models/parent_homework_model.dart';
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
      final response = await _dioClient.dio.get(ApiConstants.parentChildProfile(childId));
      final data = response.data;
      if (data == null) {
        throw ServerException('Invalid response data');
      }
      final payload = data['data'] as Map<String, dynamic>?;
      if (payload == null) {
        throw ServerException('Empty response payload');
      }
      return ParentChildProfileModel.fromJson(payload);
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
      if (data == null) {
        throw ServerException('Invalid response data');
      }
      final payload = data['data'] as List?;
      if (payload == null) {
        return const [];
      }
      return payload
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
