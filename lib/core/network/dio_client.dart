import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
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

    // 1. Auth interceptor — Bearer injection + 401 redirect
    _dio.interceptors.add(
      AuthInterceptor(prefs: prefs, navigatorKey: navigatorKey),
    );

    // 2. Full request/response logger — debug builds only
    if (kDebugMode) {
      _dio.interceptors.add(
        LogInterceptor(
          request: true,
          requestHeader: true,
          requestBody: true,   // <-- shows exact JSON sent to server
          responseHeader: false,
          responseBody: true,  // <-- shows exact JSON received from server
          error: true,
          logPrint: (object) => AppLogger.log(object),
        ),
      );
    }
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
