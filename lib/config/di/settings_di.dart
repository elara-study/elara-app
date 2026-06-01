import 'package:elara/features/settings/data/datasources/settings_remote_data_source.dart';
import 'package:elara/features/settings/data/datasources/settings_remote_data_source_impl.dart';
import 'package:elara/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:elara/features/settings/domain/repositories/settings_repository.dart';
import 'package:elara/features/settings/domain/usecases/get_profile_account_use_case.dart';
import 'package:elara/features/settings/presentation/cubits/password_security_cubit.dart';
import 'package:elara/features/settings/presentation/cubits/profile_account_cubit.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void setupSettingsDI() {
  getIt.registerLazySingleton<SettingsRemoteDataSource>(
    () => SettingsRemoteDataSourceImpl(),
  );
  getIt.registerLazySingleton<SettingsRepository>(
    () => SettingsRepositoryImpl(
      remoteDataSource: getIt<SettingsRemoteDataSource>(),
    ),
  );
  getIt.registerLazySingleton(
    () => GetProfileAccountUseCase(getIt<SettingsRepository>()),
  );
  getIt.registerFactory<PasswordSecurityCubit>(() => PasswordSecurityCubit());
  getIt.registerFactory<ProfileAccountCubit>(
    () => ProfileAccountCubit(getIt<GetProfileAccountUseCase>()),
  );
}
