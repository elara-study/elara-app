import 'package:elara/features/notifications/domain/entities/notification_preferences_entity.dart';

/// Data model extending [NotificationPreferencesEntity] with JSON serialization.
class NotificationPreferencesModel extends NotificationPreferencesEntity {
  const NotificationPreferencesModel({
    required super.groupUpdates,
    required super.streakReminders,
    required super.homeworkReminders,
    required super.newLessons,
    required super.aiProgressReports,
  });

  factory NotificationPreferencesModel.fromJson(Map<String, dynamic> json) {
    return NotificationPreferencesModel(
      groupUpdates: json['groupUpdates'] as bool? ?? true,
      streakReminders: json['streakReminders'] as bool? ?? true,
      homeworkReminders: json['homeworkReminders'] as bool? ?? true,
      newLessons: json['newLessons'] as bool? ?? true,
      aiProgressReports: json['aiProgressReports'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() => {
    'groupUpdates': groupUpdates,
    'streakReminders': streakReminders,
    'homeworkReminders': homeworkReminders,
    'newLessons': newLessons,
    'aiProgressReports': aiProgressReports,
  };
}
