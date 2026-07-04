import 'package:elara/core/network/dio_client.dart';
import 'package:elara/core/services/notification_service.dart';
import 'package:elara/features/notifications/data/datasources/notification_remote_data_source.dart';
import 'package:elara/features/notifications/data/datasources/notification_remote_data_source_impl.dart';
import 'package:elara/features/notifications/data/repositories/notification_repository_impl.dart';
import 'package:elara/features/notifications/domain/repositories/notification_repository.dart';
import 'package:elara/features/notifications/domain/usecases/get_notification_preferences_use_case.dart';
import 'package:elara/features/notifications/domain/usecases/get_notifications_use_case.dart';
import 'package:elara/features/notifications/domain/usecases/get_unread_count_use_case.dart';
import 'package:elara/features/notifications/domain/usecases/mark_all_notifications_read_use_case.dart';
import 'package:elara/features/notifications/domain/usecases/mark_multiple_notifications_read_use_case.dart';
import 'package:elara/features/notifications/domain/usecases/mark_notification_read_use_case.dart';
import 'package:elara/features/notifications/domain/usecases/register_device_token_use_case.dart';
import 'package:elara/features/notifications/domain/usecases/remove_device_token_use_case.dart';
import 'package:elara/features/notifications/domain/usecases/update_notification_preferences_use_case.dart';
import 'package:elara/features/notifications/presentation/cubits/notifications_cubit.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void setupNotificationDI() {
  // ── Services ──────────────────────────────────────────────────────────────
  // Register the core Firebase and local notification helper service.
  getIt.registerLazySingleton<NotificationService>(
    () => NotificationService.instance,
  );

  // ── Data Sources ──────────────────────────────────────────────────────────
  getIt.registerLazySingleton<NotificationRemoteDataSource>(
    () => NotificationRemoteDataSourceImpl(getIt<DioClient>().dio),
  );

  // ── Repositories ──────────────────────────────────────────────────────────
  getIt.registerLazySingleton<NotificationRepository>(
    () => NotificationRepositoryImpl(getIt<NotificationRemoteDataSource>()),
  );

  // ── Use Cases ─────────────────────────────────────────────────────────────
  getIt.registerLazySingleton<RegisterDeviceTokenUseCase>(
    () => RegisterDeviceTokenUseCase(getIt<NotificationRepository>()),
  );
  getIt.registerLazySingleton<RemoveDeviceTokenUseCase>(
    () => RemoveDeviceTokenUseCase(getIt<NotificationRepository>()),
  );
  getIt.registerLazySingleton<GetNotificationsUseCase>(
    () => GetNotificationsUseCase(getIt<NotificationRepository>()),
  );
  getIt.registerLazySingleton<MarkAllNotificationsReadUseCase>(
    () => MarkAllNotificationsReadUseCase(getIt<NotificationRepository>()),
  );
  getIt.registerLazySingleton<GetUnreadCountUseCase>(
    () => GetUnreadCountUseCase(getIt<NotificationRepository>()),
  );
  getIt.registerLazySingleton<MarkNotificationReadUseCase>(
    () => MarkNotificationReadUseCase(getIt<NotificationRepository>()),
  );
  getIt.registerLazySingleton<MarkMultipleNotificationsReadUseCase>(
    () => MarkMultipleNotificationsReadUseCase(getIt<NotificationRepository>()),
  );
  getIt.registerLazySingleton<GetNotificationPreferencesUseCase>(
    () => GetNotificationPreferencesUseCase(getIt<NotificationRepository>()),
  );
  getIt.registerLazySingleton<UpdateNotificationPreferencesUseCase>(
    () => UpdateNotificationPreferencesUseCase(getIt<NotificationRepository>()),
  );

  // ── Presentation ────────────────────────────────────────────────────────
  getIt.registerFactory<NotificationsCubit>(
    () => NotificationsCubit(
      getNotificationsUseCase: getIt<GetNotificationsUseCase>(),
      getUnreadCountUseCase: getIt<GetUnreadCountUseCase>(),
      markAllNotificationsReadUseCase: getIt<MarkAllNotificationsReadUseCase>(),
      markNotificationReadUseCase: getIt<MarkNotificationReadUseCase>(),
    ),
  );
}
