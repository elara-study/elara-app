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

  const DailyGoalEntity({
    required this.id,
    required this.label,
    required this.iconKey,
    required this.xpReward,
    required this.isCompleted,
  });

  @override
  List<Object?> get props => [id, label, iconKey, xpReward, isCompleted];
}
