import 'dart:convert';
import 'package:elara/features/student/data/rewards/models/rewards_profile_model.dart';
import 'package:elara/features/student/data/rewards/models/badge_model.dart';
import 'package:elara/features/student/data/dashboard/models/daily_goal_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RewardsLocalCache {
  final SharedPreferences _prefs;

  static const String _kProfileKey = 'CACHED_REWARDS_PROFILE';
  static const String _kBadgesKey = 'CACHED_BADGES';
  static const String _kDailyGoalsKey = 'CACHED_DAILY_GOALS';

  RewardsLocalCache(this._prefs);

  String _formatDate(DateTime dt) {
    return "${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}";
  }

  Future<RewardsProfileModel> getProfile() async {
    final jsonStr = _prefs.getString(_kProfileKey);
    if (jsonStr == null) {
      // Default initial mock stats matching screenshots:
      final yesterday = DateTime.now().subtract(const Duration(days: 1));
      final defaultProfile = RewardsProfileModel(
        totalXp: 1250,
        lessonsCompleted: 24,
        streakDays: 7,
        badgesUnlocked: 4,
        totalBadges: 8,
        level: 11,
        levelProgress: (1250 % 120) / 120.0,
        lastActivityDate: _formatDate(yesterday),
        lessonsCompletedToday: 0,
        masteredSubjects: const {'Mathematics', 'Science'},
        consecutivePerfectDays: 4,
        lastPerfectDate: _formatDate(yesterday),
      );
      await saveProfile(defaultProfile);
      return defaultProfile;
    }
    return RewardsProfileModel.fromJson(jsonDecode(jsonStr) as Map<String, dynamic>);
  }

  Future<void> saveProfile(RewardsProfileModel profile) async {
    await _prefs.setString(_kProfileKey, jsonEncode(profile.toJson()));
  }

  Future<List<BadgeModel>> getBadges() async {
    final jsonStr = _prefs.getString(_kBadgesKey);
    if (jsonStr == null) {
      // Default seed comes from the backend (getRewards() first-load path).
      // If the network was unavailable on the very first launch, return an
      // empty list — the engine will populate badges as activities complete.
      return [];
    }
    final list = jsonDecode(jsonStr) as List<dynamic>;
    return list.map((e) => BadgeModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<void> saveBadges(List<BadgeModel> badges) async {
    final list = badges.map((e) => e.toJson()).toList();
    await _prefs.setString(_kBadgesKey, jsonEncode(list));
  }

  Future<List<DailyGoalModel>> getDailyGoals() async {
    final jsonStr = _prefs.getString(_kDailyGoalsKey);
    if (jsonStr == null) {
      final defaultGoals = [
        const DailyGoalModel(
          id: 'goal-001',
          label: 'Complete 3 lessons',
          iconKey: 'book',
          xpReward: 50,
          isCompleted: false,
          progressCurrent: 2,
          progressTotal: 3,
        ),
        const DailyGoalModel(
          id: 'goal-002',
          label: 'Score 80% on a quiz',
          iconKey: 'quiz',
          xpReward: 30,
          isCompleted: true,
          progressCurrent: 1,
          progressTotal: 1,
        ),
        const DailyGoalModel(
          id: 'goal-003',
          label: 'Practice for 15 mins',
          iconKey: 'timer',
          xpReward: 25,
          isCompleted: false,
          progressCurrent: 6,
          progressTotal: 15,
        ),
      ];
      await saveDailyGoals(defaultGoals);
      return defaultGoals;
    }
    final list = jsonDecode(jsonStr) as List<dynamic>;
    return list.map((e) => DailyGoalModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<void> saveDailyGoals(List<DailyGoalModel> goals) async {
    final list = goals.map((e) => e.toJson()).toList();
    await _prefs.setString(_kDailyGoalsKey, jsonEncode(list));
  }

  Future<void> clearCache() async {
    await _prefs.remove(_kProfileKey);
    await _prefs.remove(_kBadgesKey);
    await _prefs.remove(_kDailyGoalsKey);
  }
}
