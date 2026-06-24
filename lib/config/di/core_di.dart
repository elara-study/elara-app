import 'package:elara/core/network/dio_client.dart';
import 'package:elara/core/network/network_info.dart';
import 'package:elara/core/storage/secure_token_storage.dart';
import 'package:elara/core/theme/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;

/// App-level navigator key — shared between [GoRouter] and [AuthInterceptor].
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> setupCoreDI() async {
  getIt.registerSingletonAsync<SharedPreferences>(
    () async => await SharedPreferences.getInstance(),
  );

  // Wait for async dependencies ONLY
  await getIt.allReady();

  getIt.registerLazySingleton<SecureTokenStorage>(() => SecureTokenStorage());

  getIt.registerLazySingleton<DioClient>(
    () => DioClient(
      tokenStorage: getIt<SecureTokenStorage>(),
      navigatorKey: navigatorKey,
    ),
  );
  getIt.registerLazySingleton<ThemeCubit>(() => ThemeCubit());
  getIt.registerLazySingleton<NetworkInfo>(() => NetworkInfo());
}

