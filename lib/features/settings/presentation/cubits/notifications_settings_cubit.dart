import 'package:elara/features/settings/presentation/cubits/notifications_settings_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationsSettingsCubit extends Cubit<NotificationsSettingsState> {
  NotificationsSettingsCubit() : super(const NotificationsSettingsState());

  void setStreakReminders(bool value) {
    emit(state.copyWith(streakRemindersEnabled: value));
  }

  void setHomeworkReminders(bool value) {
    emit(state.copyWith(homeworkRemindersEnabled: value));
  }

  void setNewLessons(bool value) {
    emit(state.copyWith(newLessonsEnabled: value));
  }

  void setAiProgressReports(bool value) {
    emit(state.copyWith(aiProgressReportsEnabled: value));
  }

  void setGroupUpdates(bool value) {
    emit(state.copyWith(groupUpdatesEnabled: value));
  }
}
