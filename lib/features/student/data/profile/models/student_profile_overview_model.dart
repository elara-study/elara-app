import 'package:elara/features/student/domain/profile/entities/profile_achievement_preview_entity.dart';
import 'package:elara/features/student/domain/profile/entities/profile_linked_parent_entity.dart';
import 'package:elara/features/student/domain/profile/entities/student_profile_overview_entity.dart';

/// JSON DTO for [StudentProfileOverviewEntity] (student Profile tab).
///
/// Field names follow snake_case to match typical API payloads.
class StudentProfileOverviewModel {
  const StudentProfileOverviewModel({
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

  factory StudentProfileOverviewModel.fromJson(Map<String, dynamic> json) {
    return StudentProfileOverviewModel(
      gradeLabel: json['grade_label'] as String,
      level: (json['level'] as num).toInt(),
      nextLevel: (json['next_level'] as num).toInt(),
      xpCurrent: (json['xp_current'] as num).toInt(),
      xpGoal: (json['xp_goal'] as num).toInt(),
      totalXp: (json['total_xp'] as num).toInt(),
      streakDays: (json['streak_days'] as num).toInt(),
      lessonsCompleted: (json['lessons_completed'] as num).toInt(),
      linkedParents: (json['linked_parents'] as List<dynamic>)
          .map(
            (e) => ProfileLinkedParentModel.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
      recentAchievements: (json['recent_achievements'] as List<dynamic>)
          .map(
            (e) => ProfileAchievementPreviewModel.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList(),
    );
  }

  final String gradeLabel;
  final int level;
  final int nextLevel;
  final int xpCurrent;
  final int xpGoal;
  final int totalXp;
  final int streakDays;
  final int lessonsCompleted;
  final List<ProfileLinkedParentModel> linkedParents;
  final List<ProfileAchievementPreviewModel> recentAchievements;

  StudentProfileOverviewEntity toEntity() => StudentProfileOverviewEntity(
    gradeLabel: gradeLabel,
    level: level,
    nextLevel: nextLevel,
    xpCurrent: xpCurrent,
    xpGoal: xpGoal,
    totalXp: totalXp,
    streakDays: streakDays,
    lessonsCompleted: lessonsCompleted,
    linkedParents: linkedParents.map((e) => e.toEntity()).toList(),
    recentAchievements: recentAchievements.map((e) => e.toEntity()).toList(),
  );
}

class ProfileLinkedParentModel {
  const ProfileLinkedParentModel({required this.id, required this.displayName});

  factory ProfileLinkedParentModel.fromJson(Map<String, dynamic> json) {
    return ProfileLinkedParentModel(
      id: json['id'] as String,
      displayName: json['display_name'] as String,
    );
  }

  final String id;
  final String displayName;

  ProfileLinkedParentEntity toEntity() =>
      ProfileLinkedParentEntity(id: id, displayName: displayName);
}

class ProfileAchievementPreviewModel {
  const ProfileAchievementPreviewModel({required this.label});

  factory ProfileAchievementPreviewModel.fromJson(Map<String, dynamic> json) {
    return ProfileAchievementPreviewModel(label: json['label'] as String);
  }

  final String label;

  ProfileAchievementPreviewEntity toEntity() =>
      ProfileAchievementPreviewEntity(label: label);
}
