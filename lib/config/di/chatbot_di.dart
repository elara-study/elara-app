import 'package:elara/core/network/network_info.dart';
import 'package:elara/features/student/presentation/chatbot/core/chatbot_config.dart';
import 'package:elara/features/student/data/chatbot/datasources/remote_data_source.dart';
import 'package:elara/features/student/data/chatbot/datasources/remote_data_source_impl.dart';
import 'package:elara/features/student/data/chatbot/repositories/chatbot_repository_impl.dart';
import 'package:elara/features/student/domain/chatbot/repositories/chatbot_repository.dart';
import 'package:elara/features/student/domain/chatbot/usecases/create_session_use_case.dart';
import 'package:elara/features/student/domain/chatbot/usecases/delete_session_use_case.dart';
import 'package:elara/features/student/domain/chatbot/usecases/list_sessions_use_case.dart';
import 'package:elara/features/student/domain/chatbot/usecases/load_history_use_case.dart';
import 'package:elara/features/student/domain/chatbot/usecases/send_image_use_case.dart';
import 'package:elara/features/student/domain/chatbot/usecases/send_text_use_case.dart';
import 'package:elara/features/student/presentation/chatbot/cubits/chatbot_cubit.dart';
import 'package:elara/features/student/presentation/chatbot/cubits/sessions_cubit.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void setupChatbotDI() {
  getIt.registerLazySingleton<ChatbotRemoteDataSource>(
    () => ChatbotRemoteDataSourceImpl(getIt()),
  );

  getIt.registerLazySingleton<ChatbotRepository>(
    () => ChatbotRepositoryImpl(getIt<ChatbotRemoteDataSource>()),
  );

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
