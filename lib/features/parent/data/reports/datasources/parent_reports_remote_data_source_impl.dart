import 'package:dio/dio.dart';
import 'package:elara/core/constants/api_constants.dart';
import 'package:elara/core/error/exceptions.dart';
import 'package:elara/core/network/dio_client.dart';
import 'package:elara/features/parent/data/reports/datasources/parent_reports_remote_data_source.dart';
import 'package:elara/features/parent/data/reports/models/parent_reports_overview_model.dart';

/// Real remote parent Reports API — Figma (1467:10103).
class ParentReportsRemoteDataSourceImpl
    implements ParentReportsRemoteDataSource {
  final DioClient _dioClient;

  ParentReportsRemoteDataSourceImpl(this._dioClient);

  @override
  Future<ParentReportsOverviewModel> fetchReportsOverview() async {
    try {
      final response = await _dioClient.dio.get(ApiConstants.parentReports);
      final body = response.data;
      if (body == null || body is! Map<String, dynamic>) {
        throw ServerException('Invalid server response format');
      }

      final status = body['status'] as String?;
      if (status != 'Success') {
        throw ServerException(body['message'] as String? ?? 'Failed to load reports');
      }

      final data = body['data'];
      if (data == null) {
        throw ServerException('No data returned from server');
      }

      return ParentReportsOverviewModel.fromJson(data);
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Server connection error');
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(e.toString());
    }
  }
}
