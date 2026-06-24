import 'package:elara/core/network/dio_client.dart';
import 'package:elara/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:elara/features/auth/data/datasources/auth_local_data_source_impl.dart';
import 'package:elara/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:elara/features/auth/data/datasources/auth_remote_data_source_impl.dart';
import 'package:elara/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:elara/features/auth/domain/repositories/auth_repository.dart';
import 'package:elara/features/auth/domain/usecases/complete_registration_use_case.dart';
import 'package:elara/features/auth/domain/usecases/forgot_password_use_case.dart';
import 'package:elara/features/auth/domain/usecases/get_current_user_use_case.dart';
import 'package:elara/features/auth/domain/usecases/google_sign_in_use_case.dart';
import 'package:elara/features/auth/domain/usecases/login_use_case.dart';
import 'package:elara/features/auth/domain/usecases/logout_use_case.dart';
import 'package:elara/features/auth/domain/usecases/register_use_case.dart';
import 'package:elara/features/auth/domain/usecases/reset_password_use_case.dart';
import 'package:elara/features/auth/domain/usecases/verify_email_use_case.dart';
import 'package:elara/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:elara/core/storage/secure_token_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;

void setupAuthDI() {
  // Data Sources
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(getIt<DioClient>()),
  );

  getIt.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(
      getIt<SharedPreferences>(),
      getIt<SecureTokenStorage>(),
    ),
  );

  // Repository
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: getIt<AuthRemoteDataSource>(),
      localDataSource: getIt<AuthLocalDataSource>(),
    ),
  );

  // Use Cases
  getIt.registerLazySingleton(() => LoginUseCase(getIt<AuthRepository>()));
  getIt.registerLazySingleton(() => RegisterUseCase(getIt<AuthRepository>()));
  getIt.registerLazySingleton(() => VerifyEmailUseCase(getIt<AuthRepository>()));
  getIt.registerLazySingleton(() => ForgotPasswordUseCase(getIt<AuthRepository>()));
  getIt.registerLazySingleton(() => ResetPasswordUseCase(getIt<AuthRepository>()));
  getIt.registerLazySingleton(() => GoogleSignInUseCase(getIt<AuthRepository>()));
  getIt.registerLazySingleton(() => CompleteRegistrationUseCase(getIt<AuthRepository>()));
  getIt.registerLazySingleton(() => LogoutUseCase(getIt<AuthRepository>()));
  getIt.registerLazySingleton(
    () => GetCurrentUserUseCase(getIt<AuthRepository>()),
  );

  // Cubits
  getIt.registerFactory(
    () => AuthCubit(
      loginUseCase: getIt<LoginUseCase>(),
      registerUseCase: getIt<RegisterUseCase>(),
      verifyEmailUseCase: getIt<VerifyEmailUseCase>(),
      forgotPasswordUseCase: getIt<ForgotPasswordUseCase>(),
      resetPasswordUseCase: getIt<ResetPasswordUseCase>(),
      googleSignInUseCase: getIt<GoogleSignInUseCase>(),
      completeRegistrationUseCase: getIt<CompleteRegistrationUseCase>(),
      logoutUseCase: getIt<LogoutUseCase>(),
      getCurrentUserUseCase: getIt<GetCurrentUserUseCase>(),
    ),
  );
}
