import 'dart:async';
import 'package:elara/features/student/domain/rewards/entities/badge_entity.dart';
import 'package:elara/features/student/domain/rewards/usecases/get_rewards_use_case.dart';
import 'package:elara/features/student/domain/rewards/usecases/update_rewards_stats_use_case.dart';
import 'package:elara/features/student/presentation/rewards/cubits/rewards_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class RewardsCubit extends Cubit<RewardsState> {
  final GetRewardsUseCase _getRewards;
  final UpdateRewardsStatsUseCase _updateRewards;

  final _badgeUnlockedController = StreamController<BadgeEntity>.broadcast();

  Stream<BadgeEntity> get badgeUnlockedStream => _badgeUnlockedController.stream;

  RewardsCubit(
    this._getRewards,
    this._updateRewards,
  ) : super(const RewardsInitial());

  /// Fetches the full gamification snapshot and emits [RewardsLoaded].
  /// Safe to call multiple times — acts as a manual refresh.
  Future<void> loadRewards() async {
    emit(const RewardsLoading());
    try {
      final data = await _getRewards();
      emit(
        RewardsLoaded(
          profile: data.profile,
          badges: data.badges,
          leaderboard: data.leaderboard,
          dailyGoals: data.dailyGoals,
        ),
      );
    } catch (e) {
      emit(RewardsError(e.toString()));
    }
  }

  /// Processes activities, updates stats/goals/badges locally, and notifies listeners.
  Future<void> completeActivity({
    required int xpGained,
    required double quizAccuracy,
    String? subject,
    int lessonCompletedCount = 0,
    int practiceSeconds = 0,
  }) async {
    try {
      final newlyUnlocked = await _updateRewards(
        xpGained: xpGained,
        quizAccuracy: quizAccuracy,
        subject: subject,
        lessonCompletedCount: lessonCompletedCount,
        practiceSeconds: practiceSeconds,
      );

      for (final badge in newlyUnlocked) {
        _badgeUnlockedController.add(badge);
      }

      // Refresh state from the cache
      final data = await _getRewards();
      emit(
        RewardsLoaded(
          profile: data.profile,
          badges: data.badges,
          leaderboard: data.leaderboard,
          dailyGoals: data.dailyGoals,
        ),
      );
    } catch (e) {
      emit(RewardsError(e.toString()));
    }
  }

  /// Proxy lesson completion (e.g. from resource click).
  /// TODO: Replace with actual lesson completion when lesson detail page is implemented.
  Future<void> completeLesson() async {
    await completeActivity(
      xpGained: 10, // 10 XP per lesson
      quizAccuracy: 0.0,
      lessonCompletedCount: 1,
    );
  }

  @override
  Future<void> close() {
    _badgeUnlockedController.close();
    return super.close();
  }
}
