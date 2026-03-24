import 'package:elara/core/network/dio_client.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;

Future<void> setupDependencyInjection() async {
  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  // Core
  getIt.registerLazySingleton<DioClient>(() => DioClient());

  // Data Sources
  // Register   remote data sources here

  // Repositories
  // Register   repositories here

  // Cubits
  // Register   cubits here
}
