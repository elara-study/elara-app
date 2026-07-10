import 'package:elara/features/student/domain/rewards/entities/badge_entity.dart';

/// Data model extending [BadgeEntity] with JSON serialization support.
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

  // ── Cache round-trip (internal snake_case keys) ───────────────────────────

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

  // ── Backend API response (GET /api/v1/Rewards/badges) ────────────────────
  //
  // Response shape per item:
  // { "id": 7, "title": "First Steps", "description": "...",
  //   "iconUrl": null, "isUnlocked": true, "earnedAt": "...",
  //   "progress": null | { "current": 3, "target": 7 } }
  //
  // We map the backend integer id to the canonical string id used by the
  // local rewards engine so badge-unlock rules remain unchanged.

  factory BadgeModel.fromApiJson(Map<String, dynamic> json) {
    final backendId = (json['id'] as num).toInt();
    final canonicalId = _backendIdToCanonical(backendId);
    final title = json['title'] as String? ?? '';
    final progress = json['progress'] as Map<String, dynamic>?;
    final isUnlocked = json['isUnlocked'] as bool? ?? false;
    final progressCurrent = (progress?['current'] as num?)?.toInt() ?? 0;
    final progressTotal = (progress?['target'] as num?)?.toInt() ?? 0;

    return BadgeModel(
      id: canonicalId,
      name: title,
      description: json['description'] as String? ?? '',
      iconKey: _iconKeyForTitle(title),
      isUnlocked: isUnlocked,
      // Unlocked badges: treat progress as complete.
      progressCurrent: isUnlocked ? progressTotal : progressCurrent,
      progressTotal: progressTotal,
    );
  }

  /// Maps backend integer badge IDs to the canonical string IDs the local
  /// engine uses for badge-unlock rule matching.
  static String _backendIdToCanonical(int id) {
    switch (id) {
      case 7:  return 'badge-001'; // First Steps
      case 8:  return 'badge-002'; // Quick Learner
      case 9:  return 'badge-003'; // Streak Master
      case 10: return 'badge-004'; // Quiz Champion
      case 11: return 'badge-005'; // Bookworm
      case 12: return 'badge-008'; // Legend
      case 13: return 'badge-006'; // Genius
      case 14: return 'badge-007'; // Perfect Week
      default: return 'badge-$id';
    }
  }

  /// Derives a local icon key from the badge title since the backend
  /// returns `iconUrl: null` for all badges at this stage.
  static String _iconKeyForTitle(String title) {
    switch (title.toLowerCase()) {
      case 'first steps':   return 'footsteps';
      case 'quick learner': return 'lightning';
      case 'streak master': return 'streak';
      case 'quiz champion': return 'crown';
      case 'bookworm':      return 'book';
      case 'genius':        return 'brain';
      case 'perfect week':  return 'calendar';
      case 'legend':        return 'trophy';
      default:              return 'trophy';
    }
  }
}
