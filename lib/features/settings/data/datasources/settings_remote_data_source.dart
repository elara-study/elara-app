import 'package:elara/features/settings/data/models/profile_account_model.dart';

abstract class SettingsRemoteDataSource {
  Future<ProfileAccountModel> getProfileAccount();
}
