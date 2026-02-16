import 'package:dio/dio.dart';
import 'package:elara/data/models/api_models.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final Dio _dio;
  static const String _tokenKey = 'auth_token';
  static const String _userIdKey = 'user_id';
  static const String _roleKey = 'user_role';
  static const String baseUrl = 'http://elara.runasp.net';

  AuthService(this._dio) {
    _dio.options.baseUrl = baseUrl;
  }

  Future<LoginResponse> login(String email, String password) async {
    try {
      final response = await _dio.post(
        '/api/Auth/login',
        data: LoginRequest(email: email, password: password).toJson(),
      );

      final loginResponse = LoginResponse.fromJson(response.data);
      await _saveToken(loginResponse.token);
      if (loginResponse.userId != null) {
        await _saveUserId(loginResponse.userId!);
      }
      if (loginResponse.role != null) {
        await _saveRole(loginResponse.role!);
      }

      return loginResponse;
    } catch (e) {
      throw Exception('Login failed: ${e.toString()}');
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userIdKey);
    await prefs.remove(_roleKey);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userIdKey);
  }

  Future<String?> getRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_roleKey);
  }

  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  Future<void> _saveUserId(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userIdKey, userId);
  }

  Future<void> _saveRole(String role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_roleKey, role);
  }
}
