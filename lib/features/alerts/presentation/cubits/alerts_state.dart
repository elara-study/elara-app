import 'package:elara/features/alerts/domain/entities/alert_entity.dart';

sealed class AlertsState {
  const AlertsState();
}

final class AlertsInitial extends AlertsState {
  const AlertsInitial();
}

final class AlertsLoading extends AlertsState {
  const AlertsLoading();
}

final class AlertsLoaded extends AlertsState {
  final List<AlertEntity> alerts;

  const AlertsLoaded({required this.alerts});

  int get unreadCount => alerts.where((a) => !a.isRead).length;
}

final class AlertsError extends AlertsState {
  final String message;
  const AlertsError(this.message);
}
