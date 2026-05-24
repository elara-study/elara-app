import 'package:elara/features/settings/data/datasources/settings_remote_data_source.dart';
import 'package:elara/features/settings/data/models/profile_account_model.dart';

/// Same JSON shape the backend will return; mock uses [fromJson] like production.
///
/// Real path: [ApiConstants.settingsProfileAccount]. Register [DioClient] in DI.
class SettingsRemoteDataSourceImpl implements SettingsRemoteDataSource {
  // final DioClient _dioClient;
  // SettingsRemoteDataSourceImpl(this._dioClient);

  SettingsRemoteDataSourceImpl();

  /// Mock GET /v1/settings/profile-account response body.
  static final Map<String, dynamic> mockProfileAccountJson = {
    'full_name': 'Tyler, The Creator',
    'username': 'tylerthecreator',
    'email': 'tylerthecreator@elara.study',
    'grade': '7',
    'country': 'Egypt',
    'phone_number': '+20 10 12345678',
    'subjects': ['Math', 'Science', 'English'],
  };

  @override
  Future<ProfileAccountModel> getProfileAccount() async {
    await Future<void>.delayed(const Duration(milliseconds: 120));
    return ProfileAccountModel.fromJson(mockProfileAccountJson);
    // ── REAL ───────────────────────────────────────────────────────────────
    // try {
    //   final response = await _dioClient.dio.get(
    //     ApiConstants.settingsProfileAccount,
    //   );
    //   final data = response.data;
    //   if (data is! Map<String, dynamic>) {
    //     throw ServerException('Invalid profile account response');
    //   }
    //   return ProfileAccountModel.fromJson(data);
    // } on DioException catch (e) {
    //   throw ServerException(e.message ?? 'Failed to load profile');
    // }
  }
}
