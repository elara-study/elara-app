import 'package:elara/core/network/dio_client.dart';
import 'package:elara/features/student/data/dashboard/datasources/student_remote_data_source.dart';
import 'package:elara/features/student/data/dashboard/datasources/student_remote_data_source_impl.dart';
import 'package:elara/features/student/data/dashboard/repositories/student_repository_impl.dart';
import 'package:elara/features/student/domain/dashboard/repositories/student_repository.dart';
import 'package:elara/features/student/presentation/dashboard/cubits/home/student_home_cubit.dart';
import 'package:elara/features/student/presentation/dashboard/cubits/learn/student_learn_cubit.dart';
import 'package:elara/features/student/presentation/dashboard/cubits/tab/student_tab_cubit.dart';
import 'package:elara/features/student/data/group/repositories/student_group_repository_impl.dart';
import 'package:elara/features/student/domain/group/repositories/student_group_repository.dart';
import 'package:elara/features/student/domain/group/usecases/get_group_announcements_usecase.dart';
import 'package:elara/features/student/domain/group/usecases/get_group_roadmap_usecase.dart';
import 'package:elara/features/student/domain/group/usecases/load_student_group_usecase.dart';
import 'package:elara/features/student/presentation/group/cubits/student_group_cubit.dart';
import 'package:elara/features/student/data/quiz/datasources/quiz_remote_datasource.dart';
import 'package:elara/features/student/data/quiz/repositories/quiz_repository_impl.dart';
import 'package:elara/features/student/domain/quiz/repositories/quiz_repository.dart';
import 'package:elara/features/student/domain/quiz/usecases/complete_quiz_use_case.dart';
import 'package:elara/features/student/domain/quiz/usecases/generate_quiz_use_case.dart';
import 'package:elara/features/student/domain/quiz/usecases/get_hint_use_case.dart';
import 'package:elara/features/student/domain/quiz/usecases/get_quiz_session_use_case.dart';
import 'package:elara/features/student/domain/quiz/usecases/submit_answer_use_case.dart';
import 'package:elara/features/student/domain/quiz/usecases/submit_quiz_answers_use_case.dart';
import 'package:elara/features/student/presentation/quiz/cubits/quiz_cubit.dart';
import 'package:elara/features/student/data/rewards/repositories/remote_student_rewards_repository.dart';
import 'package:elara/features/student/domain/rewards/repositories/student_rewards_repository.dart';
import 'package:elara/features/student/domain/rewards/usecases/get_student_rewards_leaderboard_usecase.dart';
import 'package:elara/features/student/domain/rewards/usecases/get_student_rewards_overview_usecase.dart';
import 'package:elara/features/student/data/rewards/datasources/rewards_remote_data_source.dart';
import 'package:elara/features/student/data/rewards/datasources/rewards_remote_data_source_impl.dart';
import 'package:elara/features/student/data/rewards/repositories/rewards_repository_impl.dart';
import 'package:elara/features/student/domain/rewards/repositories/rewards_repository.dart';
import 'package:elara/features/student/domain/rewards/usecases/get_rewards_use_case.dart';
import 'package:elara/features/student/presentation/rewards/cubits/rewards_cubit.dart';
import 'package:elara/features/student/data/profile/datasources/student_profile_remote_data_source.dart';
import 'package:elara/features/student/data/profile/datasources/student_profile_remote_data_source_impl.dart';
import 'package:elara/features/student/data/profile/repositories/student_profile_repository_impl.dart';
import 'package:elara/features/student/domain/profile/repositories/student_profile_repository.dart';
import 'package:elara/features/student/domain/profile/usecases/get_student_profile_overview_use_case.dart';
import 'package:elara/features/student/presentation/profile/cubits/student_profile_cubit.dart';
import 'package:elara/features/student/data/homework/datasources/homework_data_source.dart';
import 'package:elara/features/student/data/homework/datasources/homework_data_source_impl.dart';
import 'package:elara/features/student/data/homework/repositories/homework_repository_impl.dart';
import 'package:elara/features/student/domain/homework/repositories/homework_repository.dart';
import 'package:elara/features/student/domain/homework/usecases/get_homework_use_case.dart';
import 'package:elara/features/student/domain/homework/usecases/submit_homework_answer_use_case.dart';
import 'package:elara/features/student/presentation/homework/cubits/homework_cubit.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void setupStudentDI() {
  // ── Student: Data Source ──────────────────────────────────────────────────
  getIt.registerLazySingleton<StudentRemoteDataSource>(
    () => StudentRemoteDataSourceImpl(getIt<DioClient>()),
  );

  // ── Student: Repository ───────────────────────────────────────────────────
  getIt.registerLazySingleton<StudentRepository>(
    () => StudentRepositoryImpl(
      remoteDataSource: getIt<StudentRemoteDataSource>(),
    ),
  );

  // ── Student: Cubits ───────────────────────────────────────────────────────
  getIt.registerFactory(
    () => StudentHomeCubit(repository: getIt<StudentRepository>()),
  );
  getIt.registerFactory(
    () => StudentLearnCubit(repository: getIt<StudentRepository>()),
  );
  getIt.registerFactory(() => StudentTabCubit());

  // ── Student group (Learn) ─────────────────────────────────────────────────
  getIt.registerLazySingleton<StudentGroupRepository>(
    () => StudentGroupRepositoryImpl(dioClient: getIt<DioClient>()),
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
  getIt.registerFactory(() => RewardsCubit(getIt<GetRewardsUseCase>()));

  // ── Student Profile tab ─────────────────────────────────────────────────
  getIt.registerLazySingleton<StudentProfileRemoteDataSource>(
    () => StudentProfileRemoteDataSourceImpl(),
  );

  getIt.registerLazySingleton<StudentProfileRepository>(
    () => StudentProfileRepositoryImpl(
      remoteDataSource: getIt<StudentProfileRemoteDataSource>(),
    ),
  );
  getIt.registerLazySingleton(
    () => GetStudentProfileOverviewUseCase(getIt<StudentProfileRepository>()),
  );
  getIt.registerFactory<StudentProfileCubit>(
    () => StudentProfileCubit(getIt<GetStudentProfileOverviewUseCase>()),
  );

  // ── Quiz (Learn) ─────────────────────────────────────────────────────────
  getIt.registerLazySingleton<QuizRemoteDataSource>(
    () => QuizRemoteDataSource(getIt<DioClient>()),
  );

  getIt.registerLazySingleton<QuizRepository>(
    () => QuizRepositoryImpl(getIt<QuizRemoteDataSource>()),
  );

  // Legacy use cases (kept for mock-demo route compatibility).
  getIt.registerLazySingleton(
    () => GetQuizSessionUseCase(getIt<QuizRepository>()),
  );
  getIt.registerLazySingleton(
    () => SubmitQuizAnswersUseCase(getIt<QuizRepository>()),
  );

  // Live API use cases.
  getIt.registerLazySingleton(
    () => GenerateQuizUseCase(getIt<QuizRepository>()),
  );
  getIt.registerLazySingleton(() => GetHintUseCase(getIt<QuizRepository>()));
  getIt.registerLazySingleton(
    () => SubmitAnswerUseCase(getIt<QuizRepository>()),
  );
  getIt.registerLazySingleton(
    () => CompleteQuizUseCase(getIt<QuizRepository>()),
  );

  getIt.registerFactory<QuizCubit>(
    () => QuizCubit(
      getQuizSessionUseCase: getIt<GetQuizSessionUseCase>(),
      submitQuizAnswersUseCase: getIt<SubmitQuizAnswersUseCase>(),
      generateQuizUseCase: getIt<GenerateQuizUseCase>(),
      getHintUseCase: getIt<GetHintUseCase>(),
      submitAnswerUseCase: getIt<SubmitAnswerUseCase>(),
      completeQuizUseCase: getIt<CompleteQuizUseCase>(),
    ),
  );

  // ── Homework ──────────────────────────────────────────────────────────────
  getIt.registerLazySingleton<HomeworkDataSource>(
    () => HomeworkDataSourceImpl(dioClient: getIt<DioClient>()),
  );

  getIt.registerLazySingleton<HomeworkRepository>(
    () => HomeworkRepositoryImpl(getIt<HomeworkDataSource>()),
  );

  getIt.registerLazySingleton(
    () => GetHomeworkUseCase(getIt<HomeworkRepository>()),
  );

  getIt.registerLazySingleton(
    () => SubmitHomeworkAnswerUseCase(getIt<HomeworkRepository>()),
  );

  getIt.registerFactory<HomeworkCubit>(
    () => HomeworkCubit(
      getIt<GetHomeworkUseCase>(),
      getIt<SubmitHomeworkAnswerUseCase>(),
    ),
  );
}
