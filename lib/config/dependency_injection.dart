import 'package:elara/core/network/dio_client.dart';
import 'package:elara/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:elara/features/auth/data/datasources/auth_local_data_source_impl.dart';
import 'package:elara/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:elara/features/auth/data/datasources/auth_remote_data_source_impl.dart';
import 'package:elara/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:elara/features/auth/domain/repositories/auth_repository.dart';
import 'package:elara/features/auth/domain/usecases/get_current_user_use_case.dart';
import 'package:elara/features/auth/domain/usecases/login_use_case.dart';
import 'package:elara/features/auth/domain/usecases/logout_use_case.dart';
import 'package:elara/features/auth/domain/usecases/register_use_case.dart';
import 'package:elara/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:elara/features/student/group/data/repositories/mock_student_group_repository.dart';
import 'package:elara/features/student/group/domain/repositories/student_group_repository.dart';
import 'package:elara/features/student/group/domain/usecases/get_group_announcements_usecase.dart';
import 'package:elara/features/student/group/domain/usecases/get_group_roadmap_usecase.dart';
import 'package:elara/features/student/group/domain/usecases/load_student_group_usecase.dart';
import 'package:elara/features/student/group/presentation/cubits/student_group_cubit.dart';
import 'package:elara/features/student/quiz/data/repositories/mock_quiz_repository.dart';
import 'package:elara/features/student/quiz/domain/repositories/quiz_repository.dart';
import 'package:elara/features/student/quiz/domain/usecases/get_quiz_session_use_case.dart';
import 'package:elara/features/student/quiz/domain/usecases/submit_quiz_answers_use_case.dart';
import 'package:elara/features/student/quiz/presentation/cubits/quiz_cubit.dart';
import 'package:elara/features/student/rewards/data/repositories/remote_student_rewards_repository.dart';
import 'package:elara/features/student/rewards/domain/repositories/student_rewards_repository.dart';
import 'package:elara/features/student/rewards/domain/usecases/get_student_rewards_leaderboard_usecase.dart';
import 'package:elara/features/student/rewards/domain/usecases/get_student_rewards_overview_usecase.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;

Future<void> setupDependencyInjection() async {
  // ── External ──────────────────────────────────────────────────────────────
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  // ── Core ──────────────────────────────────────────────────────────────────
  getIt.registerLazySingleton<DioClient>(() => DioClient());

  // ── Auth: Data Sources ────────────────────────────────────────────────────
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(),
    //   pass DioClient when backend is ready:
    // () => AuthRemoteDataSourceImpl(getIt<DioClient>()),
  );

  getIt.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(getIt<SharedPreferences>()),
  );

  // ── Auth: Repository ──────────────────────────────────────────────────────
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: getIt<AuthRemoteDataSource>(),
      localDataSource: getIt<AuthLocalDataSource>(),
    ),
  );

  // ── Auth: Use Cases ───────────────────────────────────────────────────────
  getIt.registerLazySingleton(() => LoginUseCase(getIt<AuthRepository>()));
  getIt.registerLazySingleton(() => RegisterUseCase(getIt<AuthRepository>()));
  getIt.registerLazySingleton(() => LogoutUseCase(getIt<AuthRepository>()));
  getIt.registerLazySingleton(
    () => GetCurrentUserUseCase(getIt<AuthRepository>()),
  );

  // ── Auth: Cubit ───────────────────────────────────────────────────────────
  getIt.registerFactory(
    () => AuthCubit(
      loginUseCase: getIt<LoginUseCase>(),
      registerUseCase: getIt<RegisterUseCase>(),
      logoutUseCase: getIt<LogoutUseCase>(),
      getCurrentUserUseCase: getIt<GetCurrentUserUseCase>(),
    ),
  );

  // ── Student group (Learn) ─────────────────────────────────────────────────
  getIt.registerLazySingleton<StudentGroupRepository>(
    () => MockStudentGroupRepository(),
    // Live APIs: register RemoteStudentGroupRepository(getIt<DioClient>())
    // after auth sets the bearer token; confirm paths in ApiConstants.
  );

  getIt.registerLazySingleton<StudentRewardsRepository>(
    () => RemoteStudentRewardsRepository(getIt<DioClient>()),
  );

  getIt.registerLazySingleton<LoadStudentGroupUseCase>(
    () => LoadStudentGroupUseCase(getIt<StudentGroupRepository>()),
  );
  getIt.registerLazySingleton<GetGroupRoadmapUseCase>(
    () => GetGroupRoadmapUseCase(getIt<StudentGroupRepository>()),
  );
  getIt.registerLazySingleton<GetGroupAnnouncementsUseCase>(
    () => GetGroupAnnouncementsUseCase(getIt<StudentGroupRepository>()),
  );
  getIt.registerLazySingleton<GetStudentRewardsOverviewUseCase>(
    () => GetStudentRewardsOverviewUseCase(getIt<StudentRewardsRepository>()),
  );
  getIt.registerLazySingleton<GetStudentRewardsLeaderboardUseCase>(
    () =>
        GetStudentRewardsLeaderboardUseCase(getIt<StudentRewardsRepository>()),
  );

  getIt.registerFactory<StudentGroupCubit>(
    () => StudentGroupCubit(getIt<LoadStudentGroupUseCase>()),
  );

  // ── Quiz (Learn) ─────────────────────────────────────────────────────────
  getIt.registerLazySingleton<QuizRepository>(
    () => MockQuizRepository(),
    // Live API: register RemoteQuizRepository(getIt<DioClient>()) here.
  );

  getIt.registerLazySingleton(
    () => GetQuizSessionUseCase(getIt<QuizRepository>()),
  );
  getIt.registerLazySingleton(
    () => SubmitQuizAnswersUseCase(getIt<QuizRepository>()),
  );

  getIt.registerFactory<QuizCubit>(
    () => QuizCubit(
      getQuizSessionUseCase: getIt<GetQuizSessionUseCase>(),
      submitQuizAnswersUseCase: getIt<SubmitQuizAnswersUseCase>(),
    ),
  );
}
