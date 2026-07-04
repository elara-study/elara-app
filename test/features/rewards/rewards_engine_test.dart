import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:elara/features/student/data/rewards/datasources/rewards_local_cache.dart';
import 'package:elara/features/student/data/rewards/repositories/rewards_repository_impl.dart';
import 'package:elara/features/student/data/rewards/datasources/rewards_remote_data_source.dart';
import 'package:elara/features/student/data/rewards/models/rewards_profile_model.dart';
import 'package:elara/features/student/data/rewards/models/badge_model.dart';
import 'package:elara/features/student/data/rewards/models/leaderboard_entry_model.dart';
import 'package:elara/features/student/data/dashboard/models/daily_goal_model.dart';
import 'package:elara/features/student/domain/rewards/entities/badge_entity.dart';
import 'package:elara/features/student/domain/rewards/usecases/get_rewards_use_case.dart';
import 'package:elara/features/student/domain/rewards/usecases/update_rewards_stats_use_case.dart';
import 'package:elara/features/student/presentation/rewards/cubits/rewards_cubit.dart';

class FakeRewardsRemoteDataSource implements RewardsRemoteDataSource {
  @override
  Future<List<LeaderboardEntryModel>> getLeaderboard({
    String period = 'allTime',
    int page = 1,
    int pageSize = 10,
  }) async => [];
  @override
  Future<RewardsProfileModel> getRewardsProfile() async => throw UnimplementedError();
  @override
  Future<List<BadgeModel>> getBadges() async => [];
  @override
  Future<RewardsProfileModel> getRewardsSummary() async =>
      throw UnimplementedError();
}

void main() {
  SharedPreferences.setMockInitialValues({});

  late SharedPreferences prefs;
  late RewardsLocalCache cache;
  late RewardsRepositoryImpl repository;

  /// The 8 canonical badges the engine works against — all locked at 0 progress.
  Future<void> seedBadges() async {
    await cache.saveBadges([
      const BadgeModel(id: 'badge-001', name: 'First Steps',   description: 'complete 1st lesson',                  iconKey: 'footsteps', isUnlocked: false, progressCurrent: 0,  progressTotal: 1),
      const BadgeModel(id: 'badge-002', name: 'Quick Learner', description: 'complete 5 lessons in one day',         iconKey: 'lightning', isUnlocked: false, progressCurrent: 0,  progressTotal: 5),
      const BadgeModel(id: 'badge-003', name: 'Streak Master', description: 'maintain a 7-day streak',              iconKey: 'streak',    isUnlocked: false, progressCurrent: 0,  progressTotal: 7),
      const BadgeModel(id: 'badge-004', name: 'Quiz Champion', description: 'score 100% on a quiz',                 iconKey: 'crown',     isUnlocked: false, progressCurrent: 0,  progressTotal: 1),
      const BadgeModel(id: 'badge-005', name: 'Bookworm',      description: 'complete 50 lessons',                  iconKey: 'book',      isUnlocked: false, progressCurrent: 0,  progressTotal: 50),
      const BadgeModel(id: 'badge-006', name: 'Genius',        description: 'master all subjects',                  iconKey: 'brain',     isUnlocked: false, progressCurrent: 0,  progressTotal: 5),
      const BadgeModel(id: 'badge-007', name: 'Perfect Week',  description: 'complete all daily goals for a week',  iconKey: 'calendar',  isUnlocked: false, progressCurrent: 0,  progressTotal: 7),
      const BadgeModel(id: 'badge-008', name: 'Legend',        description: 'earn 10,000 XP',                       iconKey: 'trophy',    isUnlocked: false, progressCurrent: 0,  progressTotal: 10000),
    ]);
  }

  setUp(() async {
    prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    cache = RewardsLocalCache(prefs);
    repository = RewardsRepositoryImpl(FakeRewardsRemoteDataSource(), cache);
    await seedBadges();
  });

  Future<void> lockAllBadges() async {
    final badges = await cache.getBadges();
    final locked = badges.map((b) => BadgeModel(
      id: b.id,
      name: b.name,
      description: b.description,
      iconKey: b.iconKey,
      isUnlocked: false,
      progressCurrent: 0,
      progressTotal: b.progressTotal,
    )).toList();
    await cache.saveBadges(locked);
  }

  group('XP-to-Level Formula Tests', () {
    test('1250 XP matches Level 11 and 41.6% progress', () async {
      final profile = await cache.getProfile();
      expect(profile.totalXp, 1250);
      expect(profile.level, 11);
      expect(profile.levelProgress, closeTo(50 / 120.0, 0.0001));
    });

    test('XP to level progression handles floor correctly', () async {
      await repository.updateStats(xpGained: 10, quizAccuracy: 0.0);
      final profile = await cache.getProfile();
      expect(profile.totalXp, 1260);
      expect(profile.level, 11);
      expect(profile.levelProgress, 0.5);
    });
  });

  group('Streak Logic Tests', () {
    test('Streak increments if last activity was yesterday', () async {
      await repository.updateStats(xpGained: 10, quizAccuracy: 0.0);
      final profile = await cache.getProfile();
      expect(profile.streakDays, 8);
    });

    test('Streak stays same if last activity was today', () async {
      await repository.updateStats(xpGained: 10, quizAccuracy: 0.0);
      await repository.updateStats(xpGained: 10, quizAccuracy: 0.0);
      final profile = await cache.getProfile();
      expect(profile.streakDays, 8);
    });

    test('Streak resets to 1 if last activity was older than yesterday', () async {
      final oldProfile = await cache.getProfile();
      final updatedProfile = oldProfile.copyWith(lastActivityDate: '2026-06-25');
      await cache.saveProfile(updatedProfile);

      await repository.updateStats(xpGained: 10, quizAccuracy: 0.0);
      final profile = await cache.getProfile();
      expect(profile.streakDays, 1);
    });
  });

  group('Daily Goals Tests & Resets', () {
    test('Quiz with 80% accuracy completes goal-002', () async {
      await repository.updateStats(xpGained: 0, quizAccuracy: 85.0);
      final goals = await repository.getDailyGoals();
      final quizGoal = goals.firstWhere((g) => g.id == 'goal-002');
      expect(quizGoal.isCompleted, true);
      expect(quizGoal.progressCurrent, 1);
    });

    test('Goals accumulate progress when updated on the same day', () async {
      final now = DateTime.now();
      final todayStr = "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
      final currentProfile = await cache.getProfile();
      await cache.saveProfile(currentProfile.copyWith(lastActivityDate: todayStr));

      await repository.updateStats(xpGained: 0, quizAccuracy: 0.0, lessonCompletedCount: 1);
      final goals = await repository.getDailyGoals();
      final lessonGoal = goals.firstWhere((g) => g.id == 'goal-001');
      expect(lessonGoal.isCompleted, true);
      expect(lessonGoal.progressCurrent, 3);
    });

    test('Practice minutes accumulate from seconds', () async {
      final now = DateTime.now();
      final todayStr = "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
      final currentProfile = await cache.getProfile();
      await cache.saveProfile(currentProfile.copyWith(lastActivityDate: todayStr));

      await repository.updateStats(xpGained: 0, quizAccuracy: 0.0, practiceSeconds: 300);
      final goals = await repository.getDailyGoals();
      final practiceGoal = goals.firstWhere((g) => g.id == 'goal-003');
      expect(practiceGoal.progressCurrent, 11);
    });

    test('Midnight reset: lessonsCompletedToday and daily goals reset on new day', () async {
      final now = DateTime.now();
      final yesterday = now.subtract(const Duration(days: 1));
      final yesterdayStr = "${yesterday.year}-${yesterday.month.toString().padLeft(2, '0')}-${yesterday.day.toString().padLeft(2, '0')}";

      final currentProfile = await cache.getProfile();
      await cache.saveProfile(currentProfile.copyWith(
        lastActivityDate: yesterdayStr,
        lessonsCompletedToday: 3,
      ));

      // Make goals partially progress
      final currentGoals = await cache.getDailyGoals();
      final updatedGoals = currentGoals.map<DailyGoalModel>((g) {
        return DailyGoalModel(
          id: g.id,
          label: g.label,
          iconKey: g.iconKey,
          xpReward: g.xpReward,
          isCompleted: false,
          progressCurrent: g.progressTotal - 1,
          progressTotal: g.progressTotal,
        );
      }).toList();
      await cache.saveDailyGoals(updatedGoals);

      // Perform a minor activity on today to trigger new day checks
      await repository.updateStats(xpGained: 5, quizAccuracy: 0.0);

      final profile = await cache.getProfile();
      final goals = await repository.getDailyGoals();

      // Check lessonsCompletedToday is reset
      expect(profile.lessonsCompletedToday, 0);

      // Check goals progress are reset to 0
      for (final g in goals) {
        expect(g.progressCurrent, 0);
        expect(g.isCompleted, false);
      }
    });

    test('consecutivePerfectDays resets to 0 when a day is missed', () async {
      final now = DateTime.now();
      // Yesterday was missed (perfect day date was 2 days ago)
      final twoDaysAgo = now.subtract(const Duration(days: 2));
      final twoDaysAgoStr = "${twoDaysAgo.year}-${twoDaysAgo.month.toString().padLeft(2, '0')}-${twoDaysAgo.day.toString().padLeft(2, '0')}";

      final profile = await cache.getProfile();
      await cache.saveProfile(profile.copyWith(
        consecutivePerfectDays: 3,
        lastPerfectDate: twoDaysAgoStr,
      ));

      await repository.updateStats(xpGained: 10, quizAccuracy: 0.0);

      final updatedProfile = await cache.getProfile();
      expect(updatedProfile.consecutivePerfectDays, 0);
    });
  });

  group('Badge Unlock Rules Coverage', () {
    test('First Steps badge: completes 1st lesson trigger and stays locked', () async {
      await lockAllBadges();
      
      // Setup profile with 0 lessons
      final profile = await cache.getProfile();
      await cache.saveProfile(profile.copyWith(lessonsCompleted: 0));

      // Test still-locked condition (0 lessons)
      var badges = await cache.getBadges();
      expect(badges.firstWhere((b) => b.id == 'badge-001').isUnlocked, false);

      // Trigger unlock
      final unlocked = await repository.updateStats(xpGained: 0, quizAccuracy: 0.0, lessonCompletedCount: 1);
      expect(unlocked.any((b) => b.id == 'badge-001'), true);

      badges = await cache.getBadges();
      expect(badges.firstWhere((b) => b.id == 'badge-001').isUnlocked, true);
    });

    test('Quick Learner badge: completes 5 lessons in one day trigger and stays locked', () async {
      await lockAllBadges();

      // Setup profile with lessonsCompletedToday = 0
      final profile = await cache.getProfile();
      await cache.saveProfile(profile.copyWith(lessonsCompletedToday: 0));

      // Test still locked (4 lessons in a day)
      var unlocked = await repository.updateStats(xpGained: 0, quizAccuracy: 0.0, lessonCompletedCount: 4);
      expect(unlocked.any((b) => b.id == 'badge-002'), false);

      // Trigger unlock (add 1 more to reach 5)
      unlocked = await repository.updateStats(xpGained: 0, quizAccuracy: 0.0, lessonCompletedCount: 1);
      expect(unlocked.any((b) => b.id == 'badge-002'), true);

      final badges = await cache.getBadges();
      expect(badges.firstWhere((b) => b.id == 'badge-002').isUnlocked, true);
    });

    test('Streak Master badge: maintains 7-day streak trigger and stays locked', () async {
      await lockAllBadges();

      // Setup yesterday as day 5 streak (which increments to 6)
      final now = DateTime.now();
      final yesterday = now.subtract(const Duration(days: 1));
      final yesterdayStr = "${yesterday.year}-${yesterday.month.toString().padLeft(2, '0')}-${yesterday.day.toString().padLeft(2, '0')}";

      final profile = await cache.getProfile();
      await cache.saveProfile(profile.copyWith(streakDays: 5, lastActivityDate: yesterdayStr));

      // Still locked (increment from 5 to 6)
      var unlocked = await repository.updateStats(xpGained: 0, quizAccuracy: 0.0);
      expect(unlocked.any((b) => b.id == 'badge-003'), false);

      // Setup day 6 streak to trigger 7
      final updatedProfile = (await cache.getProfile()).copyWith(lastActivityDate: yesterdayStr, streakDays: 6);
      await cache.saveProfile(updatedProfile);

      // Trigger unlock (increment from 6 to 7)
      unlocked = await repository.updateStats(xpGained: 0, quizAccuracy: 0.0);
      expect(unlocked.any((b) => b.id == 'badge-003'), true);
    });

    test('Bookworm badge: completes 50 lessons trigger and stays locked', () async {
      await lockAllBadges();

      // Setup 48 lessons completed
      final profile = await cache.getProfile();
      await cache.saveProfile(profile.copyWith(lessonsCompleted: 48));

      // Still locked (49 lessons completed)
      var unlocked = await repository.updateStats(xpGained: 0, quizAccuracy: 0.0, lessonCompletedCount: 1);
      expect(unlocked.any((b) => b.id == 'badge-005'), false);

      // Trigger unlock (reach 50 lessons completed)
      unlocked = await repository.updateStats(xpGained: 0, quizAccuracy: 0.0, lessonCompletedCount: 1);
      expect(unlocked.any((b) => b.id == 'badge-005'), true);
    });

    test('Perfect Week badge: completes all daily goals for 7 days trigger and stays locked', () async {
      await lockAllBadges();

      // Setup yesterday as perfect day 5 (increments to 6)
      final now = DateTime.now();
      final yesterday = now.subtract(const Duration(days: 1));
      final yesterdayStr = "${yesterday.year}-${yesterday.month.toString().padLeft(2, '0')}-${yesterday.day.toString().padLeft(2, '0')}";
      final todayStr = "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

      final profile = await cache.getProfile();
      await cache.saveProfile(profile.copyWith(
        consecutivePerfectDays: 5,
        lastPerfectDate: yesterdayStr,
        lastActivityDate: todayStr, // Prevent midnight reset on goals
      ));

      // We complete all goals: goal-001 (Complete 3 lessons), goal-002 (Quiz 80%), goal-003 (Practice 15 mins)
      // They are already initialized to: goal-001 (2/3), goal-002 (1/1), goal-003 (6/15)
      // Let's complete the remaining progress:
      // goal-001: complete 1 lesson
      // goal-003: practice 9 minutes (540 seconds)
      var unlocked = await repository.updateStats(xpGained: 0, quizAccuracy: 90.0, lessonCompletedCount: 1, practiceSeconds: 540);
      
      // Confirm streak became 6, but Perfect Week stays locked
      var profileRefreshed = await cache.getProfile();
      expect(profileRefreshed.consecutivePerfectDays, 6);
      expect(unlocked.any((b) => b.id == 'badge-007'), false);

      // Now set perfect days to 6, lastPerfectDate yesterday, and run goals again to trigger 7 perfect days
      await cache.saveProfile(profileRefreshed.copyWith(
        consecutivePerfectDays: 6,
        lastPerfectDate: yesterdayStr,
        // Reset goals so we can complete them today again
        lastActivityDate: todayStr, 
      ));
      
      // Reset goals to partial progress
      final goals = await cache.getDailyGoals();
      final mappedGoals = goals.map<DailyGoalModel>((g) {
        return DailyGoalModel(
          id: g.id,
          label: g.label,
          iconKey: g.iconKey,
          xpReward: g.xpReward,
          isCompleted: g.id == 'goal-002' ? g.isCompleted : false,
          progressCurrent: g.id == 'goal-002' ? g.progressCurrent : 0,
          progressTotal: g.progressTotal,
        );
      }).toList();
      await cache.saveDailyGoals(mappedGoals);

      unlocked = await repository.updateStats(xpGained: 0, quizAccuracy: 100.0, lessonCompletedCount: 3, practiceSeconds: 1000);
      expect(unlocked.any((b) => b.id == 'badge-007'), true);
    });

    test('Legend badge: earns 10,000 XP trigger and stays locked', () async {
      await lockAllBadges();

      // Setup 9950 XP
      final profile = await cache.getProfile();
      await cache.saveProfile(profile.copyWith(totalXp: 9950));

      // Still locked (9990 XP)
      var unlocked = await repository.updateStats(xpGained: 40, quizAccuracy: 0.0);
      expect(unlocked.any((b) => b.id == 'badge-008'), false);

      // Trigger unlock (10010 XP)
      unlocked = await repository.updateStats(xpGained: 20, quizAccuracy: 0.0);
      expect(unlocked.any((b) => b.id == 'badge-008'), true);
    });
  });

  group('Cache Round-Trip Tests', () {
    test('save state, simulate fresh load, confirm values match exactly', () async {
      const testProfile = RewardsProfileModel(
        totalXp: 5000,
        lessonsCompleted: 42,
        streakDays: 15,
        badgesUnlocked: 6,
        totalBadges: 8,
        level: 42,
        levelProgress: 0.8,
        lastActivityDate: '2026-07-03',
        lessonsCompletedToday: 4,
        masteredSubjects: {'Chemistry', 'History'},
        consecutivePerfectDays: 5,
        lastPerfectDate: '2026-07-02',
      );

      await cache.saveProfile(testProfile);

      final freshCache = RewardsLocalCache(prefs);
      final loadedProfile = await freshCache.getProfile();

      expect(loadedProfile.totalXp, testProfile.totalXp);
      expect(loadedProfile.lessonsCompleted, testProfile.lessonsCompleted);
      expect(loadedProfile.streakDays, testProfile.streakDays);
      expect(loadedProfile.badgesUnlocked, testProfile.badgesUnlocked);
      expect(loadedProfile.totalBadges, testProfile.totalBadges);
      expect(loadedProfile.level, testProfile.level);
      expect(loadedProfile.levelProgress, testProfile.levelProgress);
      expect(loadedProfile.lastActivityDate, testProfile.lastActivityDate);
      expect(loadedProfile.lessonsCompletedToday, testProfile.lessonsCompletedToday);
      expect(loadedProfile.masteredSubjects, testProfile.masteredSubjects);
      expect(loadedProfile.consecutivePerfectDays, testProfile.consecutivePerfectDays);
      expect(loadedProfile.lastPerfectDate, testProfile.lastPerfectDate);
    });
  });

  group('Cubit Stream Broadcasting Tests', () {
    test('badgeUnlockedStream actually emits correct BadgeEntity on unlock', () async {
      final cubit = RewardsCubit(
        GetRewardsUseCase(repository),
        UpdateRewardsStatsUseCase(repository),
      );

      await lockAllBadges();
      final profile = await cache.getProfile();
      await cache.saveProfile(profile.copyWith(streakDays: 1, lessonsCompleted: 0));

      final emittedBadges = <BadgeEntity>[];
      final subscription = cubit.badgeUnlockedStream.listen((b) {
        emittedBadges.add(b);
      });

      // Complete 1 lesson to trigger First Steps
      await cubit.completeActivity(
        xpGained: 10,
        quizAccuracy: 0.0,
        lessonCompletedCount: 1,
      );

      await Future.delayed(Duration.zero);

      expect(emittedBadges.length, 1);
      expect(emittedBadges.first.id, 'badge-001');
      expect(emittedBadges.first.name, 'First Steps');

      await subscription.cancel();
      await cubit.close();
    });
  });
}
