import 'package:elara/core/error/exceptions.dart';
import 'package:elara/core/error/failures.dart';
import 'package:elara/features/settings/data/datasources/settings_remote_data_source.dart';
import 'package:elara/features/settings/domain/entities/profile_account_entity.dart';
import 'package:elara/features/settings/domain/repositories/settings_repository.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  SettingsRepositoryImpl({required SettingsRemoteDataSource remoteDataSource})
    : _remoteDataSource = remoteDataSource;

  final SettingsRemoteDataSource _remoteDataSource;

  @override
  Future<ProfileAccountEntity> getProfileAccount() async {
    try {
      final model = await _remoteDataSource.getProfileAccount();
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
