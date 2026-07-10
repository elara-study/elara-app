import 'package:elara/config/dependency_injection.dart';
import 'package:elara/core/localization/locale_repository.dart';
import 'package:elara/core/localization/locale_repository_impl.dart';
import 'package:elara/core/localization/locale_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

void setupLocaleDI() {
  getIt.registerLazySingleton<LocaleRepository>(
    () => LocaleRepositoryImpl(getIt<SharedPreferences>()),
  );
  getIt.registerLazySingleton<LocaleCubit>(
    () => LocaleCubit(getIt<LocaleRepository>()),
  );
}
