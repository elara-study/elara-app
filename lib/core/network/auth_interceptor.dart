import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:elara/config/routes.dart';
import 'package:elara/core/constants/api_constants.dart';
import 'package:elara/core/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthInterceptor extends Interceptor {
  final SharedPreferences _prefs;
  final GlobalKey<NavigatorState> navigatorKey;

  static const String _kCachedUserKey = 'CACHED_USER';

  // Guards against infinite refresh loops (e.g. refresh endpoint itself 401s).
  bool _isRefreshing = false;

  AuthInterceptor({
    required SharedPreferences prefs,
    required this.navigatorKey,
  }) : _prefs = prefs;

  // ── Request ────────────────────────────────────────────────────────────────

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = _readToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  // ── Error ──────────────────────────────────────────────────────────────────

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final statusCode = err.response?.statusCode;
    final path = err.requestOptions.path;

    // Only handle 401 once; ignore refresh endpoint itself to avoid loops.
    if (statusCode == 401 &&
        !_isRefreshing &&
        !path.contains(ApiConstants.refreshToken)) {
      _isRefreshing = true;
      AppLogger.log('AuthInterceptor → 401 on $path — attempting token refresh');

      try {
        final newTokens = await _refresh(err.requestOptions);
        if (newTokens != null) {
          // Persist the new token pair.
          _updateCachedTokens(
            newAccessToken: newTokens.$1,
            newRefreshToken: newTokens.$2,
          );
          AppLogger.log('AuthInterceptor → token refreshed successfully');

          // Retry the original request with the new access token.
          final retryOptions = err.requestOptions
            ..headers['Authorization'] = 'Bearer ${newTokens.$1}';

          // Build a fresh Dio instance to avoid interceptor re-entry.
          final retryDio = Dio(
            BaseOptions(
              baseUrl: ApiConstants.baseUrl,
              headers: {'Content-Type': 'application/json'},
            ),
          );
          final response = await retryDio.fetch(retryOptions);
          _isRefreshing = false;
          return handler.resolve(response);
        }
      } catch (e) {
        AppLogger.log('AuthInterceptor → refresh failed: $e');
      }

      // Refresh failed — clear session and go to login.
      _isRefreshing = false;
      AppLogger.log('AuthInterceptor → clearing session and redirecting to login');
      _clearSession();
      _navigateToLogin();
    }

    handler.next(err);
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  /// Calls the refresh endpoint. Returns (accessToken, refreshToken) or null.
  Future<(String, String)?> _refresh(RequestOptions original) async {
    final storedRefreshToken = _readRefreshToken();
    if (storedRefreshToken == null || storedRefreshToken.isEmpty) {
      AppLogger.log('AuthInterceptor → no refresh token stored');
      return null;
    }

    final refreshDio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        headers: {'Content-Type': 'application/json'},
      ),
    );

    final response = await refreshDio.post(
      ApiConstants.refreshToken,
      data: {'refreshToken': storedRefreshToken},
    );

    final body = response.data;
    if (body is! Map<String, dynamic>) return null;

    final status = body['status'] as String?;
    if (status != 'Success') return null;

    final data = body['data'] as Map<String, dynamic>?;
    if (data == null) return null;

    final newToken = data['token'] as String?;
    final newRefreshToken = data['refreshToken'] as String?;
    if (newToken == null || newRefreshToken == null) return null;

    return (newToken, newRefreshToken);
  }

  /// Reads `token` from the cached user JSON blob.
  String? _readToken() {
    try {
      final jsonString = _prefs.getString(_kCachedUserKey);
      if (jsonString == null) return null;
      final match = RegExp(r'"token"\s*:\s*"([^"]+)"').firstMatch(jsonString);
      return match?.group(1);
    } catch (e) {
      AppLogger.log('AuthInterceptor → failed to read token: $e');
      return null;
    }
  }

  /// Reads `refresh_token` from the cached user JSON blob.
  String? _readRefreshToken() {
    try {
      final jsonString = _prefs.getString(_kCachedUserKey);
      if (jsonString == null) return null;
      final match =
          RegExp(r'"refresh_token"\s*:\s*"([^"]+)"').firstMatch(jsonString);
      return match?.group(1);
    } catch (e) {
      AppLogger.log('AuthInterceptor → failed to read refresh token: $e');
      return null;
    }
  }

  /// Patches the cached user JSON with the new access + refresh tokens.
  void _updateCachedTokens({
    required String newAccessToken,
    required String newRefreshToken,
  }) {
    try {
      final jsonString = _prefs.getString(_kCachedUserKey);
      if (jsonString == null) return;

      final map = jsonDecode(jsonString) as Map<String, dynamic>;
      map['token'] = newAccessToken;
      map['refresh_token'] = newRefreshToken;
      _prefs.setString(_kCachedUserKey, jsonEncode(map));
    } catch (e) {
      AppLogger.log('AuthInterceptor → failed to update cached tokens: $e');
    }
  }

  void _clearSession() {
    _prefs.remove(_kCachedUserKey);
  }

  void _navigateToLogin() {
    navigatorKey.currentState?.pushNamedAndRemoveUntil(
      AppRoutes.login,
      (_) => false,
    );
  }
}
