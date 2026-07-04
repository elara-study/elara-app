import 'package:equatable/equatable.dart';

/// Domain entity representing a user's notification preference settings.
///
/// Maps to the API response schema for
/// GET/PATCH `/api/v1/notifications/preferences`.
class NotificationPreferencesEntity extends Equatable {
  final bool groupUpdates;
  final bool streakReminders;
  final bool homeworkReminders;
  final bool newLessons;
  final bool aiProgressReports;

  const NotificationPreferencesEntity({
    required this.groupUpdates,
    required this.streakReminders,
    required this.homeworkReminders,
    required this.newLessons,
    required this.aiProgressReports,
  });

  /// Creates a copy with the given fields replaced.
  NotificationPreferencesEntity copyWith({
    bool? groupUpdates,
    bool? streakReminders,
    bool? homeworkReminders,
    bool? newLessons,
    bool? aiProgressReports,
  }) {
    return NotificationPreferencesEntity(
      groupUpdates: groupUpdates ?? this.groupUpdates,
      streakReminders: streakReminders ?? this.streakReminders,
      homeworkReminders: homeworkReminders ?? this.homeworkReminders,
      newLessons: newLessons ?? this.newLessons,
      aiProgressReports: aiProgressReports ?? this.aiProgressReports,
    );
  }

  @override
  List<Object?> get props => [
    groupUpdates,
    streakReminders,
    homeworkReminders,
    newLessons,
    aiProgressReports,
  ];
}
