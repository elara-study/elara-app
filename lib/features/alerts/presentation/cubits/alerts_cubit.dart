import 'package:elara/features/alerts/data/datasources/alerts_data_source.dart';
import 'package:elara/features/alerts/domain/entities/alert_entity.dart';
import 'package:elara/features/alerts/presentation/cubits/alerts_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AlertsCubit extends Cubit<AlertsState> {
  final AlertsDataSource _dataSource;

  AlertsCubit({required AlertsDataSource dataSource})
    : _dataSource = dataSource,
      super(const AlertsInitial());

  Future<void> loadAlerts() async {
    emit(const AlertsLoading());
    try {
      final alerts = await _dataSource.getAlerts();
      emit(AlertsLoaded(alerts: alerts));
    } catch (e) {
      emit(AlertsError('Failed to load alerts: ${e.toString()}'));
    }
  }

  Future<void> markAllAsRead() async {
    try {
      await _dataSource.markAllAsRead();
      final currentState = state;
      if (currentState is AlertsLoaded) {
        final updated = currentState.alerts
            .map((a) => AlertEntity(
                  id: a.id,
                  title: a.title,
                  body: a.body,
                  date: a.date,
                  isRead: true,
                  iconAsset: a.iconAsset,
                  iconColor: a.iconColor,
                ))
            .toList();
        emit(AlertsLoaded(alerts: updated));
      }
    } catch (_) {
      // Silently fail
    }
  }
}
