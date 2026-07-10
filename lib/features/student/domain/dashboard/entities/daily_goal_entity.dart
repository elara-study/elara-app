import 'package:equatable/equatable.dart';

/// Represents a single daily goal shown in the Home screen "Daily Goals" section.
class DailyGoalEntity extends Equatable {
  final String id;

  /// Short description (e.g. "Complete 3 lessons")
  final String label;

  /// Icon identifier — maps to a MaterialIcon in the UI layer
  /// (e.g. "book", "quiz", "timer")
  final String iconKey;

  /// XP reward awarded on completion (e.g. 50)
  final int xpReward;

  /// Whether the student has already completed this goal today
  final bool isCompleted;

  /// The current progress towards this daily goal (e.g. 2 lessons completed)
  final int progressCurrent;

  /// The target progress required to complete this daily goal (e.g. 3 lessons)
  final int progressTotal;

  const DailyGoalEntity({
    required this.id,
    required this.label,
    required this.iconKey,
    required this.xpReward,
    required this.isCompleted,
    this.progressCurrent = 0,
    this.progressTotal = 1,
  });

  DailyGoalEntity copyWith({
    String? id,
    String? label,
    String? iconKey,
    int? xpReward,
    bool? isCompleted,
    int? progressCurrent,
    int? progressTotal,
  }) {
    return DailyGoalEntity(
      id: id ?? this.id,
      label: label ?? this.label,
      iconKey: iconKey ?? this.iconKey,
      xpReward: xpReward ?? this.xpReward,
      isCompleted: isCompleted ?? this.isCompleted,
      progressCurrent: progressCurrent ?? this.progressCurrent,
      progressTotal: progressTotal ?? this.progressTotal,
    );
  }

  @override
  List<Object?> get props => [
        id,
        label,
        iconKey,
        xpReward,
        isCompleted,
        progressCurrent,
        progressTotal,
      ];
}
