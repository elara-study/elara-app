import 'package:equatable/equatable.dart';

/// Notification toggles — aligned with Figma frame `432:2688`.
class NotificationsSettingsState extends Equatable {
  const NotificationsSettingsState({
    this.streakRemindersEnabled = true,
    this.homeworkRemindersEnabled = true,
    this.newLessonsEnabled = true,
    this.aiProgressReportsEnabled = true,
    this.groupUpdatesEnabled = true,
  });

  final bool streakRemindersEnabled;
  final bool homeworkRemindersEnabled;
  final bool newLessonsEnabled;
  final bool aiProgressReportsEnabled;
  final bool groupUpdatesEnabled;

  NotificationsSettingsState copyWith({
    bool? streakRemindersEnabled,
    bool? homeworkRemindersEnabled,
    bool? newLessonsEnabled,
    bool? aiProgressReportsEnabled,
    bool? groupUpdatesEnabled,
  }) {
    return NotificationsSettingsState(
      streakRemindersEnabled:
          streakRemindersEnabled ?? this.streakRemindersEnabled,
      homeworkRemindersEnabled:
          homeworkRemindersEnabled ?? this.homeworkRemindersEnabled,
      newLessonsEnabled: newLessonsEnabled ?? this.newLessonsEnabled,
      aiProgressReportsEnabled:
          aiProgressReportsEnabled ?? this.aiProgressReportsEnabled,
      groupUpdatesEnabled: groupUpdatesEnabled ?? this.groupUpdatesEnabled,
    );
  }

  @override
  List<Object?> get props => [
    streakRemindersEnabled,
    homeworkRemindersEnabled,
    newLessonsEnabled,
    aiProgressReportsEnabled,
    groupUpdatesEnabled,
  ];
}
