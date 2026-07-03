import 'package:dio/dio.dart';
import 'package:elara/core/constants/api_constants.dart';
import 'package:elara/core/network/dio_client.dart';
import 'package:elara/features/student/data/rewards/datasources/rewards_remote_data_source.dart';
import 'package:elara/features/student/data/rewards/models/badge_model.dart';
import 'package:elara/features/student/data/rewards/models/leaderboard_entry_model.dart';
import 'package:elara/features/student/data/rewards/models/rewards_profile_model.dart';

class RewardsRemoteDataSourceImpl implements RewardsRemoteDataSource {
  final DioClient _dioClient;

  RewardsRemoteDataSourceImpl(this._dioClient);

  // ── Live API ─────────────────────────────────────────────────────────────

  @override
  Future<RewardsProfileModel> getRewardsSummary() async {
    try {
      final response = await _dioClient.dio.get<dynamic>(
        ApiConstants.rewardsSummary,
      );
      final body = response.data;
      // Envelope: { "status": "...", "message": "...", "data": { ... } }
      final data = (body is Map<String, dynamic> && body['data'] is Map)
          ? body['data'] as Map<String, dynamic>
          : body as Map<String, dynamic>;
      return RewardsProfileModel.fromSummaryJson(data);
    } on DioException {
      rethrow;
    }
  }

  // ── Mocked — replace with real calls when endpoints are available ─────────

  @override
  Future<RewardsProfileModel> getRewardsProfile() async {
    // TODO: replace with DioClient call when a full-profile endpoint exists.
    await Future.delayed(const Duration(milliseconds: 300));
    return const RewardsProfileModel(
      totalXp: 1250,
      lessonsCompleted: 24,
      streakDays: 7,
      badgesUnlocked: 4,
      totalBadges: 8,
    );
  }

  @override
  Future<List<BadgeModel>> getBadges() async {
    try {
      final response = await _dioClient.dio.get<dynamic>(
        ApiConstants.rewardsBadges,
      );
      final body = response.data;
      // Envelope: { "status": "...", "message": "...", "data": [ ... ] }
      final List<dynamic> raw = (body is Map<String, dynamic> && body['data'] is List)
          ? body['data'] as List<dynamic>
          : body as List<dynamic>;
      return raw
          .whereType<Map<String, dynamic>>()
          .map(BadgeModel.fromApiJson)
          .toList();
    } on DioException {
      rethrow;
    }
  }

  @override
  Future<List<LeaderboardEntryModel>> getLeaderboard({
    String period = 'allTime',
    int page = 1,
    int pageSize = 10,
  }) async {
    try {
      final response = await _dioClient.dio.get<dynamic>(
        ApiConstants.rewardsLeaderboard(
          period: period,
          page: page,
          pageSize: pageSize,
        ),
      );
      final body = response.data;
      // Envelope: { "status": "...", "message": "...", "data": { "leaderboard": [...] } }
      final dataMap = (body is Map<String, dynamic> && body['data'] is Map)
          ? body['data'] as Map<String, dynamic>
          : <String, dynamic>{};
      final raw = dataMap['leaderboard'];
      if (raw is! List) return [];
      return raw
          .whereType<Map<String, dynamic>>()
          .map(LeaderboardEntryModel.fromApiJson)
          .toList();
    } on DioException {
      rethrow;
    }
  }
}
