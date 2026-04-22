import 'package:elara/features/student/rewards/domain/entities/rewards_profile_entity.dart';

/// Data model extending [RewardsProfileEntity] with JSON serialization support.
class RewardsProfileModel extends RewardsProfileEntity {
  const RewardsProfileModel({
    required super.totalXp,
    required super.lessonsCompleted,
    required super.streakDays,
    required super.badgesUnlocked,
    required super.totalBadges,
  });

  factory RewardsProfileModel.fromJson(Map<String, dynamic> json) {
    return RewardsProfileModel(
      totalXp: (json['total_xp'] as num).toInt(),
      lessonsCompleted: (json['lessons_completed'] as num).toInt(),
      streakDays: (json['streak_days'] as num).toInt(),
      badgesUnlocked: (json['badges_unlocked'] as num).toInt(),
      totalBadges: (json['total_badges'] as num).toInt(),
    );
  }

  Map<String, dynamic> toJson() => {
        'total_xp': totalXp,
        'lessons_completed': lessonsCompleted,
        'streak_days': streakDays,
        'badges_unlocked': badgesUnlocked,
        'total_badges': totalBadges,
      };
}
