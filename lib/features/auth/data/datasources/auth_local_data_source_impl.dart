import 'dart:convert';

import 'package:elara/core/error/exceptions.dart';
import 'package:elara/core/storage/secure_token_storage.dart';
import 'package:elara/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:elara/features/auth/data/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _kCachedUserKey = 'CACHED_USER';

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences _prefs;
  final SecureTokenStorage _tokenStorage;

  AuthLocalDataSourceImpl(this._prefs, this._tokenStorage);

  @override
  Future<void> cacheUser(UserModel user) async {
    await _tokenStorage.saveTokens(
      accessToken: user.token,
      refreshToken: user.refreshToken,
    );

    final profile = <String, dynamic>{
      'id': user.id,
      'full_name': user.fullName,
      'email': user.email,
      'role': user.role.value,
    };
    await _prefs.setString(_kCachedUserKey, jsonEncode(profile));
  }

  @override
  Future<String?> getAccessToken() => _tokenStorage.getAccessToken();

  @override
  Future<String?> getRefreshToken() => _tokenStorage.getRefreshToken();

  @override
  Future<UserModel?> getCachedUser() async {
    final token = await getAccessToken();
    if (token == null || token.isEmpty) return null;

    final jsonString = _prefs.getString(_kCachedUserKey);
    if (jsonString == null) return null;

    try {
      final map = jsonDecode(jsonString) as Map<String, dynamic>;
      map['token'] = token;
      map['refresh_token'] = await getRefreshToken();
      return UserModel.fromJson(map);
    } catch (_) {
      throw CacheException('Failed to load cached user');
    }
  }

  @override
  Future<void> clearUser() async {
    await _prefs.remove(_kCachedUserKey);
    await _tokenStorage.clearTokens();
  }
}
