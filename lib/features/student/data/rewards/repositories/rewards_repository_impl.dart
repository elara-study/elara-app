import 'package:elara/features/student/data/rewards/datasources/rewards_remote_data_source.dart';
import 'package:elara/features/student/data/rewards/datasources/rewards_local_cache.dart';
import 'package:elara/features/student/data/rewards/models/rewards_profile_model.dart';
import 'package:elara/features/student/data/rewards/models/badge_model.dart';
import 'package:elara/features/student/data/dashboard/models/daily_goal_model.dart';
import 'package:elara/features/student/domain/rewards/repositories/rewards_repository.dart';
import 'package:elara/features/student/domain/dashboard/entities/daily_goal_entity.dart';
import 'package:elara/features/student/domain/rewards/entities/badge_entity.dart';

class RewardsRepositoryImpl implements RewardsRepository {
  final RewardsRemoteDataSource _remoteDataSource;
  final RewardsLocalCache _localCache;

  const RewardsRepositoryImpl(this._remoteDataSource, this._localCache);

  String _formatDate(DateTime dt) {
    return "${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}";
  }

  @override
  Future<RewardsData> getRewards() async {
    // Attempt to seed the local cache from the live endpoints the very first
    // time (i.e. when the cache has never been written). On every subsequent
    // call the cache is already warm from local activity tracking, so we
    // skip the network round-trips.
    final cachedProfile = await _localCache.getProfile();
    final isFirstLoad = cachedProfile.lastActivityDate == null &&
        cachedProfile.totalXp == 0;

    if (isFirstLoad) {
      try {
        // Fetch profile summary and badges in parallel.
        final results = await Future.wait([
          _remoteDataSource.getRewardsSummary(),
          _remoteDataSource.getBadges(),
        ]);
        await _localCache.saveProfile(results[0] as RewardsProfileModel);
        await _localCache.saveBadges(results[1] as List<BadgeModel>);
      } catch (_) {
        // Network unavailable — continue with the default empty cache.
      }
    }

    final profile = await _localCache.getProfile();
    final badges = await _localCache.getBadges();
    final leaderboard = await _remoteDataSource.getLeaderboard();
    final dailyGoals = await _localCache.getDailyGoals();

    return RewardsData(
      profile: profile,
      badges: badges,
      leaderboard: leaderboard,
      dailyGoals: dailyGoals,
    );
  }

  @override
  Future<List<DailyGoalEntity>> getDailyGoals() async {
    return await _localCache.getDailyGoals();
  }

  @override
  Future<List<BadgeEntity>> updateStats({
    required int xpGained,
    required double quizAccuracy,
    String? subject,
    int lessonCompletedCount = 0,
    int practiceSeconds = 0,
  }) async {
    final now = DateTime.now();
    final todayStr = _formatDate(now);

    // 1. Load current states
    final profile = await _localCache.getProfile();
    final badges = await _localCache.getBadges();
    final goals = await _localCache.getDailyGoals();

    // 2. Midnight Reset / New Day Check
    final isNewDay = profile.lastActivityDate != todayStr;
    int lessonsCompletedToday = isNewDay ? 0 : profile.lessonsCompletedToday;
    
    List<DailyGoalModel> activeGoals = goals;
    if (isNewDay) {
      // Reset goals to 0 for a new calendar day
      activeGoals = goals.map((g) {
        return DailyGoalModel(
          id: g.id,
          label: g.label,
          iconKey: g.iconKey,
          xpReward: g.xpReward,
          isCompleted: false,
          progressCurrent: 0,
          progressTotal: g.progressTotal,
        );
      }).toList();
    }

    // 3. Perfect Days Gap Detection
    int consecutivePerfectDays = profile.consecutivePerfectDays;
    final yesterdayStr = _formatDate(now.subtract(const Duration(days: 1)));
    
    // If the gap is longer than yesterday, reset consecutive perfect days
    if (profile.lastPerfectDate != todayStr && profile.lastPerfectDate != yesterdayStr) {
      consecutivePerfectDays = 0;
    }

    // 4. Streak Calculation
    int streakDays = profile.streakDays;
    if (profile.lastActivityDate == yesterdayStr) {
      streakDays += 1;
    } else if (profile.lastActivityDate != todayStr) {
      // Missed a day (and not today's first activity), reset streak to 1
      streakDays = 1;
    }

    // 5. Update Activity Progress
    int newLessonsCompleted = profile.lessonsCompleted + lessonCompletedCount;
    lessonsCompletedToday += lessonCompletedCount;
    int currentXp = profile.totalXp + xpGained;

    // 6. Update Daily Goals
    int bonusXp = 0;
    final updatedGoals = activeGoals.map((g) {
      if (g.isCompleted) return g;

      int progress = g.progressCurrent;
      if (g.id == 'goal-001') {
        progress = (progress + lessonCompletedCount).clamp(0, g.progressTotal);
      } else if (g.id == 'goal-002') {
        if (quizAccuracy >= 80.0) {
          progress = 1;
        }
      } else if (g.id == 'goal-003') {
        int practiceMins = (practiceSeconds / 60).round();
        progress = (progress + practiceMins).clamp(0, g.progressTotal);
      }

      final isNowCompleted = progress >= g.progressTotal;
      if (isNowCompleted) {
        bonusXp += g.xpReward;
      }

      return DailyGoalModel(
        id: g.id,
        label: g.label,
        iconKey: g.iconKey,
        xpReward: g.xpReward,
        isCompleted: isNowCompleted,
        progressCurrent: progress,
        progressTotal: g.progressTotal,
      );
    }).toList();

    currentXp += bonusXp;

    // 7. Check if all daily goals are completed today
    bool allGoalsCompleted = updatedGoals.every((g) => g.isCompleted);
    String? lastPerfectDate = profile.lastPerfectDate;
    if (allGoalsCompleted && lastPerfectDate != todayStr) {
      if (lastPerfectDate == yesterdayStr) {
        consecutivePerfectDays += 1;
      } else {
        consecutivePerfectDays = 1;
      }
      lastPerfectDate = todayStr;
    }

    // 8. Update Subject Mastery
    final masteredSubjects = Set<String>.from(profile.masteredSubjects);
    if (quizAccuracy == 100.0 && subject != null && subject.trim().isNotEmpty) {
      masteredSubjects.add(subject.trim());
    }

    // 9. Validate Badge Rules & track newly unlocked
    final newlyUnlocked = <BadgeEntity>[];
    final updatedBadges = badges.map((b) {
      if (b.isUnlocked) return b;

      bool shouldUnlock = false;
      int progressCurrent = b.progressCurrent;

      if (b.id == 'badge-001') {
        progressCurrent = newLessonsCompleted;
        shouldUnlock = newLessonsCompleted >= 1;
      } else if (b.id == 'badge-002') {
        progressCurrent = lessonsCompletedToday;
        shouldUnlock = lessonsCompletedToday >= 5;
      } else if (b.id == 'badge-003') {
        progressCurrent = streakDays;
        shouldUnlock = streakDays >= 7;
      } else if (b.id == 'badge-004') {
        progressCurrent = quizAccuracy == 100.0 ? 1 : 0;
        shouldUnlock = quizAccuracy == 100.0;
      } else if (b.id == 'badge-005') {
        progressCurrent = newLessonsCompleted;
        shouldUnlock = newLessonsCompleted >= b.progressTotal;
      } else if (b.id == 'badge-006') {
        progressCurrent = masteredSubjects.length;
        shouldUnlock = masteredSubjects.length >= b.progressTotal;
      } else if (b.id == 'badge-007') {
        progressCurrent = consecutivePerfectDays;
        shouldUnlock = consecutivePerfectDays >= b.progressTotal;
      } else if (b.id == 'badge-008') {
        progressCurrent = currentXp;
        shouldUnlock = currentXp >= b.progressTotal;
      }

      if (shouldUnlock) {
        final unlockedBadge = BadgeModel(
          id: b.id,
          name: b.name,
          description: b.description,
          iconKey: b.iconKey,
          isUnlocked: true,
          progressCurrent: b.progressTotal,
          progressTotal: b.progressTotal,
        );
        newlyUnlocked.add(unlockedBadge);
        return unlockedBadge;
      }

      return BadgeModel(
        id: b.id,
        name: b.name,
        description: b.description,
        iconKey: b.iconKey,
        isUnlocked: false,
        progressCurrent: progressCurrent,
        progressTotal: b.progressTotal,
      );
    }).toList();

    // 10. Level Formula Calculation
    int level = 1 + (currentXp / 120).floor();
    double levelProgress = (currentXp % 120) / 120.0;

    // 11. Save everything back to cache
    final updatedProfile = RewardsProfileModel(
      totalXp: currentXp,
      lessonsCompleted: newLessonsCompleted,
      streakDays: streakDays,
      badgesUnlocked: profile.badgesUnlocked + newlyUnlocked.length,
      totalBadges: profile.totalBadges,
      level: level,
      levelProgress: levelProgress,
      lastActivityDate: todayStr,
      lessonsCompletedToday: lessonsCompletedToday,
      masteredSubjects: masteredSubjects,
      consecutivePerfectDays: consecutivePerfectDays,
      lastPerfectDate: lastPerfectDate,
    );

    await _localCache.saveProfile(updatedProfile);
    await _localCache.saveBadges(updatedBadges);
    await _localCache.saveDailyGoals(updatedGoals);

    return newlyUnlocked;
  }
}
