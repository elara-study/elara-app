import 'package:elara/features/student/domain/rewards/entities/leaderboard_entry_entity.dart';

/// Data model extending [LeaderboardEntryEntity] with JSON serialization support.
class LeaderboardEntryModel extends LeaderboardEntryEntity {
  const LeaderboardEntryModel({
    required super.rank,
    required super.name,
    required super.xp,
    super.isCurrentUser = false,
  });

  // ── Cache round-trip (internal snake_case keys) ───────────────────────────

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

  // ── Backend API response (GET /api/v1/Rewards/leaderboard) ───────────────
  //
  // Response shape per item:
  // { "rank": 1, "userId": "...", "name": "You", "avatarUrl": null,
  //   "xp": 440, "isCurrentUser": true }

  factory LeaderboardEntryModel.fromApiJson(Map<String, dynamic> json) {
    return LeaderboardEntryModel(
      rank: (json['rank'] as num).toInt(),
      name: json['name'] as String? ?? '',
      xp: (json['xp'] as num? ?? 0).toInt(),
      isCurrentUser: json['isCurrentUser'] as bool? ?? false,
    );
  }
}

