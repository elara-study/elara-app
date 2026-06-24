import 'package:dio/dio.dart';
import 'package:elara/config/routes.dart';
import 'package:elara/core/constants/api_constants.dart';
import 'package:elara/core/storage/secure_token_storage.dart';
import 'package:elara/core/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AuthInterceptor extends Interceptor {
  final SecureTokenStorage _tokenStorage;
  final GlobalKey<NavigatorState> navigatorKey;
  GoRouter? _router;

  bool _isRefreshing = false;

  VoidCallback? onSessionExpired;

  AuthInterceptor({
    required SecureTokenStorage tokenStorage,
    required this.navigatorKey,
  }) : _tokenStorage = tokenStorage;

  void bindRouter(GoRouter router) => _router = router;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _tokenStorage.getAccessToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final statusCode = err.response?.statusCode;
    final path = err.requestOptions.path;

    if (statusCode == 401 &&
        !_isRefreshing &&
        !path.contains(ApiConstants.refreshToken)) {
      _isRefreshing = true;
      AppLogger.log('AuthInterceptor → 401 on $path — attempting token refresh');

      try {
        final newTokens = await _refresh(err.requestOptions);
        if (newTokens != null) {
          await _tokenStorage.saveTokens(
            accessToken: newTokens.$1,
            refreshToken: newTokens.$2,
          );
          AppLogger.log('AuthInterceptor → token refreshed successfully');

          final retryOptions = err.requestOptions
            ..headers['Authorization'] = 'Bearer ${newTokens.$1}';

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

      _isRefreshing = false;
      AppLogger.log('AuthInterceptor → clearing session and redirecting to login');
      await _tokenStorage.clearTokens();
      onSessionExpired?.call();
      _navigateToLogin();
    }

    handler.next(err);
  }

  Future<(String, String)?> _refresh(RequestOptions original) async {
    final storedRefreshToken = await _tokenStorage.getRefreshToken();
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

  void _navigateToLogin() {
    if (_router != null) {
      _router!.go(AppRoutes.login);
      return;
    }
    navigatorKey.currentState?.pushNamedAndRemoveUntil(
      AppRoutes.login,
      (_) => false,
    );
  }
}
