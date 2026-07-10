import 'package:dio/dio.dart';
import 'package:elara/core/constants/api_constants.dart';
import 'package:elara/core/error/exceptions.dart';
import 'package:elara/core/network/dio_client.dart';
import 'package:elara/features/parent/data/profile/models/parent_profile_model.dart';

abstract class ParentProfileRemoteDataSource {
  Future<ParentProfileModel> getParentProfile();
}

class ParentProfileRemoteDataSourceImpl implements ParentProfileRemoteDataSource {
  final DioClient _dioClient;

  ParentProfileRemoteDataSourceImpl(this._dioClient);

  @override
  Future<ParentProfileModel> getParentProfile() async {
    try {
      final response = await _dioClient.dio.get(ApiConstants.parentProfile);
      final body = response.data;
      if (body == null || body is! Map<String, dynamic>) {
        throw ServerException('Invalid server response format');
      }

      final status = body['status'] as String?;
      if (status != 'Success') {
        throw ServerException(body['message'] as String? ?? 'Failed to load profile');
      }

      final data = body['data'] as Map<String, dynamic>?;
      if (data == null) {
        throw ServerException('No data returned from server');
      }

      return ParentProfileModel.fromJson(data);
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Server connection error');
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(e.toString());
    }
  }
}
