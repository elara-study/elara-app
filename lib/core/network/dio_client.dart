import 'package:dio/dio.dart';
import 'package:elara/core/constants/api_constants.dart';
import 'package:elara/core/network/auth_interceptor.dart';
import 'package:elara/core/storage/secure_token_storage.dart';
import 'package:elara/core/utils/logger.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DioClient {
  late Dio _dio;
  late final AuthInterceptor _authInterceptor;

  DioClient({
    required SecureTokenStorage tokenStorage,
    required GlobalKey<NavigatorState> navigatorKey,
  }) {
    _authInterceptor = AuthInterceptor(
      tokenStorage: tokenStorage,
      navigatorKey: navigatorKey,
    );

    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(
          milliseconds: ApiConstants.connectionTimeout,
        ),
        receiveTimeout: const Duration(
          milliseconds: ApiConstants.receiveTimeout,
        ),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _dio.interceptors.add(_authInterceptor);

    if (kDebugMode) {
      _dio.interceptors.add(
        LogInterceptor(
          request: true,
          requestHeader: true,
          requestBody: true,
          responseHeader: false,
          responseBody: true,
          error: true,
          logPrint: (object) => AppLogger.log(object),
        ),
      );
    }
  }

  Dio get dio => _dio;

  AuthInterceptor get authInterceptor => _authInterceptor;

  void bindRouter(GoRouter router) {
    _authInterceptor.bindRouter(router);
  }

  Future<void> setAuthToken(String token) async {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  void removeAuthToken() {
    _dio.options.headers.remove('Authorization');
  }
}
