import 'package:elara/features/alerts/domain/entities/alert_entity.dart';

/// Contract for fetching alerts data.
abstract class AlertsDataSource {
  Future<List<AlertEntity>> getAlerts();
  Future<void> markAllAsRead();
}
