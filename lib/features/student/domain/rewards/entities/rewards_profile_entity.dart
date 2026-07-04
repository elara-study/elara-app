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

  /// The calculated level of the student.
  final int level;

  /// Progress fraction (0.0 to 1.0) within the current level.
  final double levelProgress;

  /// The last activity completion date (in YYYY-MM-DD).
  final String? lastActivityDate;

  /// Number of lessons completed today.
  final int lessonsCompletedToday;

  /// Set of subject names mastered (quizzes completed with 100% accuracy).
  final Set<String> masteredSubjects;

  /// Consecutive days where all daily goals were completed.
  final int consecutivePerfectDays;

  /// The last date when all daily goals were fully completed (in YYYY-MM-DD).
  final String? lastPerfectDate;

  const RewardsProfileEntity({
    required this.totalXp,
    required this.lessonsCompleted,
    required this.streakDays,
    required this.badgesUnlocked,
    required this.totalBadges,
    this.level = 11,
    this.levelProgress = 0.0,
    this.lastActivityDate,
    this.lessonsCompletedToday = 0,
    this.masteredSubjects = const {},
    this.consecutivePerfectDays = 0,
    this.lastPerfectDate,
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
    level,
    levelProgress,
    lastActivityDate,
    lessonsCompletedToday,
    masteredSubjects,
    consecutivePerfectDays,
    lastPerfectDate,
  ];
}
