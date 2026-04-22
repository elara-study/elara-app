import 'package:elara/features/student/rewards/domain/usecases/get_rewards_use_case.dart';
import 'package:elara/features/student/rewards/presentation/cubits/rewards_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

/// Manages the Rewards screen state (badges + leaderboard + profile stats).
///
/// Call [loadRewards] once (triggered eagerly in [BlocProvider.create] inside
/// [StudentShell]) and [switchTab] to toggle between Badges / Leaderboard
/// without triggering a second network call.
@injectable
class RewardsCubit extends Cubit<RewardsState> {
  final GetRewardsUseCase _getRewards;

  RewardsCubit(this._getRewards) : super(const RewardsInitial());

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
        ),
      );
    } catch (e) {
      emit(RewardsError(e.toString()));
    }
  }

  /// Switches the active tab (0 = Badges, 1 = Leaderboard) without re-fetching.
  /// No-op if the data is not yet loaded.
  void switchTab(int tab) {
    final current = state;
    if (current is RewardsLoaded) {
      emit(current.withTab(tab));
    }
  }
}
