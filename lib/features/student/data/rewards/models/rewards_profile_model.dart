import 'package:elara/features/student/domain/rewards/entities/rewards_profile_entity.dart';

/// Data model extending [RewardsProfileEntity] with JSON serialization support.
class RewardsProfileModel extends RewardsProfileEntity {
  const RewardsProfileModel({
    required super.totalXp,
    required super.lessonsCompleted,
    required super.streakDays,
    required super.badgesUnlocked,
    required super.totalBadges,
    super.level = 11,
    super.levelProgress = 0.0,
    super.lastActivityDate,
    super.lessonsCompletedToday = 0,
    super.masteredSubjects = const {},
    super.consecutivePerfectDays = 0,
    super.lastPerfectDate,
  });

  factory RewardsProfileModel.fromJson(Map<String, dynamic> json) {
    return RewardsProfileModel(
      totalXp: (json['total_xp'] as num).toInt(),
      lessonsCompleted: (json['lessons_completed'] as num).toInt(),
      streakDays: (json['streak_days'] as num).toInt(),
      badgesUnlocked: (json['badges_unlocked'] as num).toInt(),
      totalBadges: (json['total_badges'] as num).toInt(),
      level: (json['level'] as num?)?.toInt() ?? 11,
      levelProgress: (json['level_progress'] as num?)?.toDouble() ?? 0.0,
      lastActivityDate: json['last_activity_date'] as String?,
      lessonsCompletedToday: (json['lessons_completed_today'] as num?)?.toInt() ?? 0,
      masteredSubjects: (json['mastered_subjects'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toSet() ??
          const <String>{},
      consecutivePerfectDays: (json['consecutive_perfect_days'] as num?)?.toInt() ?? 0,
      lastPerfectDate: json['last_perfect_date'] as String?,
    );
  }

  /// Parses the `GET /api/v1/Rewards/summary` response envelope:
  /// ```json
  /// { "totalXp": 440, "lessonsCompleted": 25, "streakDays": 3,
  ///   "badges": { "earned": 3, "total": 8 } }
  /// ```
  /// Fields that the summary doesn't include (level, date tracking, etc.)
  /// are computed locally or left at their defaults so the engine can take over.
  factory RewardsProfileModel.fromSummaryJson(Map<String, dynamic> json) {
    final badgesMap = json['badges'] as Map<String, dynamic>? ?? {};
    final totalXp = (json['totalXp'] as num).toInt();
    final level = 1 + (totalXp / 120).floor();
    final levelProgress = (totalXp % 120) / 120.0;
    return RewardsProfileModel(
      totalXp: totalXp,
      lessonsCompleted: (json['lessonsCompleted'] as num).toInt(),
      streakDays: (json['streakDays'] as num).toInt(),
      badgesUnlocked: (badgesMap['earned'] as num? ?? 0).toInt(),
      totalBadges: (badgesMap['total'] as num? ?? 8).toInt(),
      level: level,
      levelProgress: levelProgress,
    );
  }


  Map<String, dynamic> toJson() => {
    'total_xp': totalXp,
    'lessons_completed': lessonsCompleted,
    'streak_days': streakDays,
    'badges_unlocked': badgesUnlocked,
    'total_badges': totalBadges,
    'level': level,
    'level_progress': levelProgress,
    'last_activity_date': lastActivityDate,
    'lessons_completed_today': lessonsCompletedToday,
    'mastered_subjects': masteredSubjects.toList(),
    'consecutive_perfect_days': consecutivePerfectDays,
    'last_perfect_date': lastPerfectDate,
  };

  RewardsProfileModel copyWith({
    int? totalXp,
    int? lessonsCompleted,
    int? streakDays,
    int? badgesUnlocked,
    int? totalBadges,
    int? level,
    double? levelProgress,
    String? lastActivityDate,
    int? lessonsCompletedToday,
    Set<String>? masteredSubjects,
    int? consecutivePerfectDays,
    String? lastPerfectDate,
  }) {
    return RewardsProfileModel(
      totalXp: totalXp ?? this.totalXp,
      lessonsCompleted: lessonsCompleted ?? this.lessonsCompleted,
      streakDays: streakDays ?? this.streakDays,
      badgesUnlocked: badgesUnlocked ?? this.badgesUnlocked,
      totalBadges: totalBadges ?? this.totalBadges,
      level: level ?? this.level,
      levelProgress: levelProgress ?? this.levelProgress,
      lastActivityDate: lastActivityDate ?? this.lastActivityDate,
      lessonsCompletedToday: lessonsCompletedToday ?? this.lessonsCompletedToday,
      masteredSubjects: masteredSubjects ?? this.masteredSubjects,
      consecutivePerfectDays: consecutivePerfectDays ?? this.consecutivePerfectDays,
      lastPerfectDate: lastPerfectDate ?? this.lastPerfectDate,
    );
  }
}
