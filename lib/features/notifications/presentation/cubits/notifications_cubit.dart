import 'package:elara/features/notifications/domain/usecases/get_notifications_use_case.dart';
import 'package:elara/features/notifications/domain/usecases/get_unread_count_use_case.dart';
import 'package:elara/features/notifications/domain/usecases/mark_all_notifications_read_use_case.dart';
import 'package:elara/features/notifications/domain/usecases/mark_notification_read_use_case.dart';
import 'package:elara/features/notifications/presentation/cubits/notifications_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  final GetNotificationsUseCase _getNotificationsUseCase;
  final GetUnreadCountUseCase _getUnreadCountUseCase;
  final MarkAllNotificationsReadUseCase _markAllNotificationsReadUseCase;
  final MarkNotificationReadUseCase _markNotificationReadUseCase;

  NotificationsCubit({
    required GetNotificationsUseCase getNotificationsUseCase,
    required GetUnreadCountUseCase getUnreadCountUseCase,
    required MarkAllNotificationsReadUseCase markAllNotificationsReadUseCase,
    required MarkNotificationReadUseCase markNotificationReadUseCase,
  })  : _getNotificationsUseCase = getNotificationsUseCase,
        _getUnreadCountUseCase = getUnreadCountUseCase,
        _markAllNotificationsReadUseCase = markAllNotificationsReadUseCase,
        _markNotificationReadUseCase = markNotificationReadUseCase,
        super(const NotificationsInitial());

  Future<void> loadNotifications() async {
    emit(const NotificationsLoading());
    final notificationsResult = await _getNotificationsUseCase(page: 1, limit: 20);
    final unreadResult = await _getUnreadCountUseCase();

    notificationsResult.fold(
      onSuccess: (notifications) {
        final unreadCount = unreadResult.fold(
          onSuccess: (count) => count,
          onFailure: (_) => 0,
        );
        emit(NotificationsLoaded(
          notifications: notifications,
          unreadCount: unreadCount,
        ));
      },
      onFailure: (failure) => emit(NotificationsError(failure.message)),
    );
  }

  Future<void> markAllAsRead() async {
    final result = await _markAllNotificationsReadUseCase();
    result.fold(
      onSuccess: (_) {
        final currentState = state;
        if (currentState is NotificationsLoaded) {
          final updated = currentState.notifications
              .map((n) => n.copyWith(isRead: true))
              .toList();
          emit(NotificationsLoaded(
            notifications: updated,
            unreadCount: 0,
          ));
        }
      },
      onFailure: (_) {},
    );
  }

  Future<void> markAsRead(String id) async {
    final result = await _markNotificationReadUseCase(id);
    result.fold(
      onSuccess: (_) {
        final currentState = state;
        if (currentState is NotificationsLoaded) {
          final updated = currentState.notifications
              .map((n) => n.id == id ? n.copyWith(isRead: true) : n)
              .toList();
          final newUnreadCount = updated.where((n) => !n.isRead).length;
          emit(NotificationsLoaded(
            notifications: updated,
            unreadCount: newUnreadCount,
          ));
        }
      },
      onFailure: (_) {},
    );
  }
}
