import 'package:elara/core/error/exceptions.dart';
import 'package:elara/core/error/failures.dart';
import 'package:elara/features/student/data/profile/datasources/student_profile_remote_data_source.dart';
import 'package:elara/features/student/domain/profile/entities/student_profile_overview_entity.dart';
import 'package:elara/features/student/domain/profile/repositories/student_profile_repository.dart';

class StudentProfileRepositoryImpl implements StudentProfileRepository {
  StudentProfileRepositoryImpl({
    required StudentProfileRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  final StudentProfileRemoteDataSource _remoteDataSource;

  @override
  Future<StudentProfileOverviewEntity> getProfileOverview() async {
    try {
      final model = await _remoteDataSource.getProfileOverview();
      return model.toEntity();
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    } on NetworkException catch (e) {
      throw NetworkFailure(e.message);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }
}
