import 'package:equatable/equatable.dart';

/// A single achievement badge.
///
/// [progressCurrent] and [progressTotal] are only meaningful for
/// locked badges where partial progress is tracked (e.g. 24/50 lessons).
/// For unlocked badges both values are typically 0 or equal.
class BadgeEntity extends Equatable {
  final String id;
  final String name;
  final String description;

  /// Key used to resolve the badge icon (e.g. 'trophy', 'book', 'star').
  final String iconKey;

  final bool isUnlocked;
  final int progressCurrent;
  final int progressTotal;

  const BadgeEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.iconKey,
    required this.isUnlocked,
    this.progressCurrent = 0,
    this.progressTotal = 0,
  });

  BadgeEntity copyWith({
    String? id,
    String? name,
    String? description,
    String? iconKey,
    bool? isUnlocked,
    int? progressCurrent,
    int? progressTotal,
  }) {
    return BadgeEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      iconKey: iconKey ?? this.iconKey,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      progressCurrent: progressCurrent ?? this.progressCurrent,
      progressTotal: progressTotal ?? this.progressTotal,
    );
  }

  /// Progress fraction [0.0 – 1.0] — safe to use directly in a LinearProgressIndicator.
  double get progressPercent => progressTotal > 0
      ? (progressCurrent / progressTotal).clamp(0.0, 1.0)
      : 0.0;

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    iconKey,
    isUnlocked,
    progressCurrent,
    progressTotal,
  ];
}
