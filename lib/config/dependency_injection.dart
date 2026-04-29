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
import 'package:elara/features/student/presentation/cubits/tab/student_tab_cubit.dart';
import 'package:elara/features/student/data/datasources/student_remote_data_source.dart';
import 'package:elara/features/student/data/datasources/student_remote_data_source_impl.dart';
import 'package:elara/features/student/data/repositories/student_repository_impl.dart';
import 'package:elara/features/student/domain/repositories/student_repository.dart';
import 'package:elara/features/student/presentation/cubits/home/student_home_cubit.dart';
import 'package:elara/features/student/presentation/cubits/learn/student_learn_cubit.dart';
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
import 'package:elara/features/student/rewards/data/datasources/rewards_remote_data_source.dart';
import 'package:elara/features/student/rewards/data/datasources/rewards_remote_data_source_impl.dart';
import 'package:elara/features/student/rewards/data/repositories/rewards_repository_impl.dart';
import 'package:elara/features/student/rewards/domain/repositories/rewards_repository.dart';
import 'package:elara/features/student/rewards/domain/usecases/get_rewards_use_case.dart';
import 'package:elara/features/student/rewards/presentation/cubits/rewards_cubit.dart';
import 'package:elara/features/student/homework/data/datasources/homework_data_source.dart';
import 'package:elara/features/student/homework/data/datasources/homework_data_source_impl.dart';
import 'package:elara/features/student/homework/data/repositories/homework_repository_impl.dart';
import 'package:elara/features/student/homework/domain/repositories/homework_repository.dart';
import 'package:elara/features/student/homework/domain/usecases/get_homework_use_case.dart';
import 'package:elara/features/student/homework/presentation/cubits/homework_cubit.dart';
import 'package:elara/features/teacher/data/datasources/teacher_home_data_source.dart';
import 'package:elara/features/teacher/data/datasources/teacher_home_data_source_impl.dart';
import 'package:elara/features/teacher/presentation/cubits/teacher_home_cubit.dart';

import 'package:elara/core/network/network_info.dart';
import 'package:elara/features/student/chatbot/core/chatbot_config.dart';
import 'package:elara/features/student/chatbot/data/repositories/mock_chatbot_repository.dart';
import 'package:elara/features/student/chatbot/domain/repositories/chatbot_repository.dart';
import 'package:elara/features/student/chatbot/domain/usecases/create_session_use_case.dart';
import 'package:elara/features/student/chatbot/domain/usecases/delete_session_use_case.dart';
import 'package:elara/features/student/chatbot/domain/usecases/list_sessions_use_case.dart';
import 'package:elara/features/student/chatbot/domain/usecases/load_history_use_case.dart';
import 'package:elara/features/student/chatbot/domain/usecases/send_image_use_case.dart';
import 'package:elara/features/student/chatbot/domain/usecases/send_text_use_case.dart';
import 'package:elara/features/student/chatbot/presentation/cubits/chatbot_cubit.dart';
import 'package:elara/features/student/chatbot/presentation/cubits/sessions_cubit.dart';

import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;

Future<void> setupDependencyInjection() async {
  // ── External ──────────────────────────────────────────────────────────────
  getIt.registerSingletonAsync<SharedPreferences>(
    () async => await SharedPreferences.getInstance(),
  );

  // Wait for async dependencies ONLY (important)
  await getIt.allReady();

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

  // ── Student: Data Source ──────────────────────────────────────────────────
  getIt.registerLazySingleton<StudentRemoteDataSource>(
    () => StudentRemoteDataSourceImpl(),
    // TODO: pass DioClient when backend is ready:
    // () => StudentRemoteDataSourceImpl(getIt<DioClient>()),
  );

  // ── Student: Repository ───────────────────────────────────────────────────
  getIt.registerLazySingleton<StudentRepository>(
    () => StudentRepositoryImpl(
      remoteDataSource: getIt<StudentRemoteDataSource>(),
    ),
  );

  // ── Student: Cubits ───────────────────────────────────────────────────────
  // Factories so each shell tab gets its own independent instance
  getIt.registerFactory(
    () => StudentHomeCubit(repository: getIt<StudentRepository>()),
  );
  getIt.registerFactory(
    () => StudentLearnCubit(repository: getIt<StudentRepository>()),
  );

  // Factory — BlocProvider closes the cubit on dispose; a fresh instance is
  // needed each time StudentShell mounts (e.g. after app restart).
  // ── Student group (Learn) ─────────────────────────────────────────────────
  // Factory: must not be a singleton — [BlocProvider] closes the cubit when the
  // shell disposes; a reused closed singleton would throw on emit.
  getIt.registerFactory(() => StudentTabCubit());

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

  // ── Rewards Gamification: Data Source ────────────────────────────────────
  getIt.registerLazySingleton<RewardsRemoteDataSource>(
    () => RewardsRemoteDataSourceImpl(),
    // TODO: pass DioClient when backend is ready:
    // () => RewardsRemoteDataSourceImpl(getIt<DioClient>()),
  );

  // ── Rewards Gamification: Repository ────────────────────────────────────
  getIt.registerLazySingleton<RewardsRepository>(
    () => RewardsRepositoryImpl(getIt<RewardsRemoteDataSource>()),
  );

  // ── Rewards Gamification: Use Case ───────────────────────────────────────
  getIt.registerLazySingleton(
    () => GetRewardsUseCase(getIt<RewardsRepository>()),
  );

  // ── Rewards Gamification: Cubit ──────────────────────────────────────────
  // Factory so each shell entry creates a fresh instance
  getIt.registerFactory(() => RewardsCubit(getIt<GetRewardsUseCase>()));

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

  // ── Homework ──────────────────────────────────────────────────────────────
  getIt.registerLazySingleton<HomeworkDataSource>(
    () => HomeworkDataSourceImpl(),
    // TODO: pass DioClient when backend is ready:
    // () => HomeworkDataSourceImpl(getIt<DioClient>()),
  );

  getIt.registerLazySingleton<HomeworkRepository>(
    () => HomeworkRepositoryImpl(getIt<HomeworkDataSource>()),
  );

  getIt.registerLazySingleton(
    () => GetHomeworkUseCase(getIt<HomeworkRepository>()),
  );

  // Factory: BlocProvider closes the cubit on dispose; fresh instance needed.
  getIt.registerFactory<HomeworkCubit>(
    () => HomeworkCubit(getIt<GetHomeworkUseCase>()),
  );

   // ── Teacher ──────────────────────────────────────────────────────────────
  getIt.registerLazySingleton<TeacherHomeDataSource>(
    () => const TeacherHomeDataSourceImpl(),
  );

  // Factory: each TeacherShell gets its own cubit instance.
  getIt.registerFactory<TeacherHomeCubit>(
    () => TeacherHomeCubit(getIt<TeacherHomeDataSource>()),
 
  // ── Chatbot (Student) ────────────────────────────────────────────────────
  getIt.registerLazySingleton<NetworkInfo>(() => NetworkInfo());

  ///
  /// Live stack (register below instead):
  /// `ChatbotRemoteDataSourceImpl(getIt<DioClient>())` +
  /// `ChatbotRepositoryImpl(getIt<ChatbotRemoteDataSource>())`.
  getIt.registerLazySingleton<ChatbotRepository>(() => MockChatbotRepository());

  getIt.registerLazySingleton(
    () => CreateSessionUseCase(getIt<ChatbotRepository>()),
  );
  getIt.registerLazySingleton(
    () => ListSessionsUseCase(getIt<ChatbotRepository>()),
  );
  getIt.registerLazySingleton(
    () => LoadHistoryUseCase(getIt<ChatbotRepository>()),
  );
  getIt.registerLazySingleton(
    () => SendTextUseCase(getIt<ChatbotRepository>()),
  );
  getIt.registerLazySingleton(
    () => SendImageUseCase(getIt<ChatbotRepository>()),
  );
  getIt.registerLazySingleton(
    () => DeleteSessionUseCase(getIt<ChatbotRepository>()),
  );

  getIt.registerFactory<ChatbotCubit>(
    () => ChatbotCubit(
      createSessionUseCase: getIt<CreateSessionUseCase>(),
      listSessionsUseCase: getIt<ListSessionsUseCase>(),
      loadHistoryUseCase: getIt<LoadHistoryUseCase>(),
      sendTextUseCase: getIt<SendTextUseCase>(),
      sendImageUseCase: getIt<SendImageUseCase>(),
      deleteSessionUseCase: getIt<DeleteSessionUseCase>(),
      networkInfo: getIt<NetworkInfo>(),
      defaultClusterId: ChatbotConfig.defaultClusterId,
    ),
  );

  getIt.registerFactory<SessionsCubit>(
    () => SessionsCubit(
      listSessionsUseCase: getIt<ListSessionsUseCase>(),
      createSessionUseCase: getIt<CreateSessionUseCase>(),
      deleteSessionUseCase: getIt<DeleteSessionUseCase>(),
      networkInfo: getIt<NetworkInfo>(),
      defaultClusterId: ChatbotConfig.defaultClusterId,
    ),
   );
}
