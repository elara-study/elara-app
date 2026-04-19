import 'package:elara/features/student/rewards/domain/entities/leaderboard_entry_entity.dart';

/// Data model extending [LeaderboardEntryEntity] with JSON serialization support.
class LeaderboardEntryModel extends LeaderboardEntryEntity {
  const LeaderboardEntryModel({
    required super.rank,
    required super.name,
    required super.xp,
    super.isCurrentUser = false,
  });

  factory LeaderboardEntryModel.fromJson(Map<String, dynamic> json) {
    return LeaderboardEntryModel(
      rank: (json['rank'] as num).toInt(),
      name: json['name'] as String,
      xp: (json['xp'] as num).toInt(),
      isCurrentUser: json['is_current_user'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'rank': rank,
        'name': name,
        'xp': xp,
        'is_current_user': isCurrentUser,
      };
}
