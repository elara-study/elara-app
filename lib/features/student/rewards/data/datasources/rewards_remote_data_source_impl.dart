import 'package:elara/features/student/rewards/data/datasources/rewards_remote_data_source.dart';
import 'package:elara/features/student/rewards/data/models/badge_model.dart';
import 'package:elara/features/student/rewards/data/models/leaderboard_entry_model.dart';
import 'package:elara/features/student/rewards/data/models/rewards_profile_model.dart';

/// MOCKED implementation — realistic data matching the design screenshots.
///
/// To switch to real API when backend is ready:
///   1. Inject [DioClient] via constructor.
///   2. Replace each [Future.delayed] block with the corresponding Dio call.
///   3. Parse responses using the model [fromJson] factories.
///   4. Update [dependency_injection.dart] to pass [getIt<DioClient>()].
class RewardsRemoteDataSourceImpl implements RewardsRemoteDataSource {
  // TODO: inject DioClient when backend is ready
  // final DioClient _dioClient;
  // RewardsRemoteDataSourceImpl(this._dioClient);

  RewardsRemoteDataSourceImpl();

  @override
  Future<RewardsProfileModel> getRewardsProfile() async {
    await Future.delayed(const Duration(milliseconds: 600));
    return const RewardsProfileModel(
      totalXp: 1250,
      lessonsCompleted: 24,
      streakDays: 7,
      badgesUnlocked: 4,
      totalBadges: 8,
    );
    // ── REAL ────────────────────────────────────────────────────────────────
    // final response = await _dioClient.dio.get('student/rewards/profile');
    // return RewardsProfileModel.fromJson(response.data);
  }

  @override
  Future<List<BadgeModel>> getBadges() async {
    await Future.delayed(const Duration(milliseconds: 600));
    return const [
      // ── Unlocked (gold) ────────────────────────────────────────────────
      BadgeModel(
        id: 'badge-001',
        name: 'First Steps',
        description: 'Complete your first lesson',
        iconKey: 'trophy',
        isUnlocked: true,
      ),
      BadgeModel(
        id: 'badge-002',
        name: 'Quick Learner',
        description: 'Complete 5 lessons in one day',
        iconKey: 'trophy',
        isUnlocked: true,
      ),
      BadgeModel(
        id: 'badge-003',
        name: 'Streak Master',
        description: 'Maintain a 7-day streak',
        iconKey: 'trophy',
        isUnlocked: true,
      ),
      BadgeModel(
        id: 'badge-004',
        name: 'Quiz Champion',
        description: 'Score 100% on a quiz',
        iconKey: 'trophy',
        isUnlocked: true,
      ),
      // ── Locked (gray + progress) ───────────────────────────────────────
      BadgeModel(
        id: 'badge-005',
        name: 'Bookworm',
        description: 'Complete 50 lessons',
        iconKey: 'lock',
        isUnlocked: false,
        progressCurrent: 24,
        progressTotal: 50,
      ),
      BadgeModel(
        id: 'badge-006',
        name: 'Genius',
        description: 'Master all subjects',
        iconKey: 'lock',
        isUnlocked: false,
        progressCurrent: 2,
        progressTotal: 5,
      ),
      BadgeModel(
        id: 'badge-007',
        name: 'Perfect Week',
        description: 'Complete all daily goals for a week',
        iconKey: 'lock',
        isUnlocked: false,
        progressCurrent: 4,
        progressTotal: 7,
      ),
      BadgeModel(
        id: 'badge-008',
        name: 'Legend',
        description: 'Earn 10,000 XP',
        iconKey: 'lock',
        isUnlocked: false,
        progressCurrent: 1250,
        progressTotal: 10000,
      ),
    ];
    // ── REAL ────────────────────────────────────────────────────────────────
    // final response = await _dioClient.dio.get('student/rewards/badges');
    // return (response.data as List).map(BadgeModel.fromJson).toList();
  }

  @override
  Future<List<LeaderboardEntryModel>> getLeaderboard() async {
    await Future.delayed(const Duration(milliseconds: 600));
    return const [
      LeaderboardEntryModel(rank: 1, name: 'Emma S.', xp: 3240),
      LeaderboardEntryModel(rank: 2, name: 'Liam K.', xp: 2890),
      LeaderboardEntryModel(rank: 3, name: 'Olivia M.', xp: 2650),
      LeaderboardEntryModel(rank: 4, name: 'You', xp: 1250, isCurrentUser: true),
      LeaderboardEntryModel(rank: 5, name: 'Noah J.', xp: 1180),
    ];
    // ── REAL ────────────────────────────────────────────────────────────────
    // final response = await _dioClient.dio.get('student/rewards/leaderboard');
    // return (response.data as List).map(LeaderboardEntryModel.fromJson).toList();
  }
}
