import 'package:elara/features/settings/domain/entities/profile_account_entity.dart';
import 'package:elara/features/settings/domain/repositories/settings_repository.dart';

class GetProfileAccountUseCase {
  GetProfileAccountUseCase(this._repository);

  final SettingsRepository _repository;

  Future<ProfileAccountEntity> call() => _repository.getProfileAccount();
}
