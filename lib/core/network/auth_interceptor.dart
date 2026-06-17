import 'package:dio/dio.dart';
import 'package:elara/config/routes.dart';
import 'package:elara/core/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthInterceptor extends Interceptor {
  final SharedPreferences _prefs;
  final GlobalKey<NavigatorState> navigatorKey;

  static const String _kCachedUserKey = 'CACHED_USER';

  AuthInterceptor({
    required SharedPreferences prefs,
    required this.navigatorKey,
  }) : _prefs = prefs;

  //   Request

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = _readToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
      AppLogger.log('AuthInterceptor → Bearer token injected');
    }
    handler.next(options);
  }

  //   Error

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      AppLogger.log(
        'AuthInterceptor → 401 received on ${err.requestOptions.path}. '
        'Clearing session and redirecting to login.',
      );
      _clearSession();
      _navigateToLogin();
    }
    handler.next(err);
  }

  String? _readToken() {
    try {
      final jsonString = _prefs.getString(_kCachedUserKey);
      if (jsonString == null) return null;
      final tokenMatch = RegExp(
        r'"token"\s*:\s*"([^"]+)"',
      ).firstMatch(jsonString);
      return tokenMatch?.group(1);
    } catch (e) {
      AppLogger.log('AuthInterceptor → failed to read token: $e');
      return null;
    }
  }

  /// Removes the cached user from SharedPreferences.
  void _clearSession() {
    _prefs.remove(_kCachedUserKey);
  }

  /// Pushes `/login` and clears the entire back-stack.
  void _navigateToLogin() {
    navigatorKey.currentState?.pushNamedAndRemoveUntil(
      AppRoutes.login,
      (_) => false,
    );
  }
}
