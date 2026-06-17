import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/api_constants.dart';
import '../utils/logger.dart';
import 'auth_interceptor.dart';

class DioClient {
  late Dio _dio;

  DioClient({
    required SharedPreferences prefs,
    required GlobalKey<NavigatorState> navigatorKey,
  }) {
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

    // Auth interceptor — Bearer injection + 401 redirect
    _dio.interceptors.add(
      AuthInterceptor(prefs: prefs, navigatorKey: navigatorKey),
    );

    // Logging interceptor (active in all modes; swap to kDebugMode guard if needed)
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          AppLogger.log('REQUEST[${options.method}] => PATH: ${options.path}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          AppLogger.log(
            'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}',
          );
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          AppLogger.log(
            'ERROR[${e.response?.statusCode}] => PATH: ${e.requestOptions.path}',
          );
          AppLogger.log('ERROR MESSAGE: ${e.message}');
          return handler.next(e);
        },
      ),
    );
  }

  Dio get dio => _dio;

  // Add authorization token
  void setAuthToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  // Remove authorization token
  void removeAuthToken() {
    _dio.options.headers.remove('Authorization');
  }
}

