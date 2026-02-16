import 'package:elara/core/network/dio_client.dart';
import 'package:elara/domain/services/ai_service.dart';
import 'package:elara/domain/repositories/rubric_repository.dart';
import 'package:elara/domain/repositories/student_performance_repository.dart';
import 'package:elara/presentation/teacher/bloc/essay_grading_bloc.dart';
import 'package:elara/presentation/teacher/bloc/quiz_generation_bloc.dart';
import 'package:elara/presentation/teacher/bloc/student_detail_bloc.dart';
import 'package:elara/data/services/auth_service.dart';
import 'package:elara/data/api/class_api_service.dart';
import 'package:elara/data/api/quiz_api_service.dart';
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
  getIt.registerLazySingleton<RubricRepository>(() => RubricRepository());
  getIt.registerLazySingleton<StudentPerformanceRepository>(() => StudentPerformanceRepository());

  // Services
  getIt.registerLazySingleton<AiService>(() => AiService());
  getIt.registerLazySingleton<AuthService>(() => AuthService(getIt<DioClient>().dio));
  getIt.registerLazySingleton<ClassApiService>(() => ClassApiService(getIt<DioClient>().dio));
  getIt.registerLazySingleton<QuizApiService>(() => QuizApiService(getIt<DioClient>().dio));

  // BLoCs
  getIt.registerFactory<QuizGenerationBloc>(() => QuizGenerationBloc(getIt<AiService>()));
  getIt.registerFactory<EssayGradingBloc>(() => EssayGradingBloc(getIt<AiService>()));
  getIt.registerFactory<StudentDetailBloc>(() => StudentDetailBloc(getIt<StudentPerformanceRepository>()));
}
