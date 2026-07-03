import 'package:dio/dio.dart';
import 'package:elara/core/error/exceptions.dart';
import 'package:elara/core/error/failures.dart';
import 'package:elara/features/parent/data/home/datasources/parent_home_remote_data_source.dart';
import 'package:elara/features/parent/domain/home/entities/parent_child_progress_entity.dart';
import 'package:elara/features/parent/domain/home/entities/parent_children_dashboard_entity.dart';
import 'package:elara/features/parent/domain/home/entities/parent_home_overview_entity.dart';
import 'package:elara/features/parent/domain/home/repositories/parent_home_repository.dart';

/// Maps parent home DTOs to domain entities.
class ParentHomeRepositoryImpl implements ParentHomeRepository {
  const ParentHomeRepositoryImpl(this._remote);

  final ParentHomeRemoteDataSource _remote;

  @override
  Future<ParentHomeOverviewEntity> getHomeOverview() async {
    try {
      final model = await _remote.fetchHomeOverview();
      return model.toEntity();
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    } on DioException catch (e) {
      throw ServerFailure.fromDioException(e);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<List<ParentChildProgressEntity>> getLinkedChildren() async {
    try {
      final models = await _remote.fetchLinkedChildren();
      return models.map((m) => m.toEntity()).toList();
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    } on DioException catch (e) {
      throw ServerFailure.fromDioException(e);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<ParentChildrenDashboardEntity> getChildrenDashboard() async {
    try {
      final model = await _remote.fetchChildrenDashboard();
      return model.toEntity();
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    } on DioException catch (e) {
      throw ServerFailure.fromDioException(e);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }
}
