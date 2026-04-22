import 'package:equatable/equatable.dart';

/// Aggregated gamification profile shown in the Achievements header.
///
/// Fetched independently by [RewardsCubit] so the Rewards screen is
/// self-contained and does not depend on [StudentHomeCubit] being alive.
class RewardsProfileEntity extends Equatable {
  /// Cumulative experience points earned by the student.
  final int totalXp;

  /// Total lessons completed across all groups.
  final int lessonsCompleted;

  /// Current consecutive-day learning streak.
  final int streakDays;

  /// Number of badges the student has unlocked so far.
  final int badgesUnlocked;

  /// Total badges available on the platform.
  final int totalBadges;

  const RewardsProfileEntity({
    required this.totalXp,
    required this.lessonsCompleted,
    required this.streakDays,
    required this.badgesUnlocked,
    required this.totalBadges,
  });

  /// Formatted badge count label, e.g. "4/8".
  String get badgesLabel => '$badgesUnlocked/$totalBadges';

  @override
  List<Object?> get props => [
        totalXp,
        lessonsCompleted,
        streakDays,
        badgesUnlocked,
        totalBadges,
      ];
}
