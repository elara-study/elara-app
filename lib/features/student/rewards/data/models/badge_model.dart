import 'package:elara/features/student/rewards/domain/entities/badge_entity.dart';

/// Data model extending [BadgeEntity] with JSON serialization support.
///
/// Adds a [fromJson] factory for when the backend is ready.
/// The mock constructor is const for use in [RewardsRemoteDataSourceImpl].
class BadgeModel extends BadgeEntity {
  const BadgeModel({
    required super.id,
    required super.name,
    required super.description,
    required super.iconKey,
    required super.isUnlocked,
    super.progressCurrent = 0,
    super.progressTotal = 0,
  });

  factory BadgeModel.fromJson(Map<String, dynamic> json) {
    return BadgeModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      iconKey: json['icon_key'] as String,
      isUnlocked: json['is_unlocked'] as bool,
      progressCurrent: (json['progress_current'] as num?)?.toInt() ?? 0,
      progressTotal: (json['progress_total'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'icon_key': iconKey,
        'is_unlocked': isUnlocked,
        'progress_current': progressCurrent,
        'progress_total': progressTotal,
      };
}
