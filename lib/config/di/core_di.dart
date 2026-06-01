import 'package:elara/core/network/dio_client.dart';
import 'package:elara/core/network/network_info.dart';
import 'package:elara/core/theme/theme_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;

Future<void> setupCoreDI() async {
  getIt.registerSingletonAsync<SharedPreferences>(
    () async => await SharedPreferences.getInstance(),
  );

  // Wait for async dependencies ONLY
  await getIt.allReady();

  getIt.registerLazySingleton<DioClient>(() => DioClient());
  getIt.registerLazySingleton<ThemeCubit>(() => ThemeCubit());
  getIt.registerLazySingleton<NetworkInfo>(() => NetworkInfo());
}
