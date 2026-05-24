import 'package:elara/features/parent/data/profile/datasources/parent_profile_remote_data_source.dart';
import 'package:elara/features/parent/domain/profile/entities/parent_profile_entity.dart';
import 'package:elara/features/parent/domain/profile/repositories/parent_profile_repository.dart';

class ParentProfileRepositoryImpl implements ParentProfileRepository {
  const ParentProfileRepositoryImpl(this._remoteDataSource);

  final ParentProfileRemoteDataSource _remoteDataSource;

  @override
  Future<ParentProfileEntity> getParentProfile() async {
    final data = await _remoteDataSource.getParentProfile();
    return ParentProfileEntity(
      phoneNumber: data['phoneNumber'] as String,
      averageCompletionPercentage: data['averageCompletionPercentage'] as int,
      averageAttendancePercentage: data['averageAttendancePercentage'] as int,
    );
  }
}
