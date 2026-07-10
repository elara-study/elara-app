import 'package:elara/features/student/domain/profile/entities/profile_achievement_preview_entity.dart';
import 'package:elara/features/student/domain/profile/entities/profile_linked_parent_entity.dart';
import 'package:equatable/equatable.dart';

/// Gamification + social snapshot for the student Profile tab.
///
/// Backed by [StudentProfileRepository] → [StudentProfileRemoteDataSource]
/// (mock in [StudentProfileRemoteDataSourceImpl] until the API exists).
class StudentProfileOverviewEntity extends Equatable {
  const StudentProfileOverviewEntity({
    required this.gradeLabel,
    required this.level,
    required this.nextLevel,
    required this.xpCurrent,
    required this.xpGoal,
    required this.totalXp,
    required this.streakDays,
    required this.lessonsCompleted,
    required this.linkedParents,
    required this.recentAchievements,
  });

  final String gradeLabel;
  final int level;
  final int nextLevel;

  /// Numerator for level progress (e.g. XP counted toward next level).
  final int xpCurrent;

  /// Denominator target for the progress bar.
  final int xpGoal;

  /// Shown on the Total XP stat card.
  final int totalXp;
  final int streakDays;
  final int lessonsCompleted;
  final List<ProfileLinkedParentEntity> linkedParents;
  final List<ProfileAchievementPreviewEntity> recentAchievements;

  int get xpToNextLevel => (xpGoal - xpCurrent).clamp(0, xpGoal);

  @override
  List<Object?> get props => [
    gradeLabel,
    level,
    nextLevel,
    xpCurrent,
    xpGoal,
    totalXp,
    streakDays,
    lessonsCompleted,
    linkedParents,
    recentAchievements,
  ];
}
