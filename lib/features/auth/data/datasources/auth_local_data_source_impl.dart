import 'dart:convert';
import 'package:elara/core/error/exceptions.dart';
import 'package:elara/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:elara/features/auth/data/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _kCachedUserKey = 'CACHED_USER';

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences _prefs;

  AuthLocalDataSourceImpl(this._prefs);

  @override
  Future<void> cacheUser(UserModel user) async {
    await _prefs.setString(_kCachedUserKey, jsonEncode(user.toJson()));
  }

  @override
  Future<UserModel?> getCachedUser() async {
    final jsonString = _prefs.getString(_kCachedUserKey);
    if (jsonString == null) return null;
    try {
      return UserModel.fromJson(
        jsonDecode(jsonString) as Map<String, dynamic>,
      );
    } catch (_) {
      throw CacheException('Failed to load cached user');
    }
  }

  @override
  Future<void> clearUser() async {
    await _prefs.remove(_kCachedUserKey);
  }
}
