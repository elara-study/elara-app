import 'package:elara/features/settings/domain/entities/profile_account_entity.dart';

/// Settings-area data shared across roles (profile account, etc.).
abstract class SettingsRepository {
  Future<ProfileAccountEntity> getProfileAccount();
}
