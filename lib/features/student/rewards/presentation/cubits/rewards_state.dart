import 'package:elara/features/student/rewards/domain/entities/badge_entity.dart';
import 'package:elara/features/student/rewards/domain/entities/leaderboard_entry_entity.dart';
import 'package:elara/features/student/rewards/domain/entities/rewards_profile_entity.dart';
import 'package:equatable/equatable.dart';

abstract class RewardsState extends Equatable {
  const RewardsState();

  @override
  List<Object?> get props => [];
}

class RewardsInitial extends RewardsState {
  const RewardsInitial();
}

class RewardsLoading extends RewardsState {
  const RewardsLoading();
}

class RewardsLoaded extends RewardsState {
  final RewardsProfileEntity profile;
  final List<BadgeEntity> badges;
  final List<LeaderboardEntryEntity> leaderboard;

  /// 0 = Badges tab, 1 = Leaderboard tab.
  ///
  /// Stored inside the state so [RewardsCubit.switchTab] can emit a new
  /// [RewardsLoaded] with the same data but a different active tab —
  /// no re-fetch, no [StatefulWidget] required.
  final int activeTab;

  const RewardsLoaded({
    required this.profile,
    required this.badges,
    required this.leaderboard,
    this.activeTab = 0,
  });

  /// Returns a copy with only [activeTab] changed.
  RewardsLoaded withTab(int tab) => RewardsLoaded(
        profile: profile,
        badges: badges,
        leaderboard: leaderboard,
        activeTab: tab,
      );

  @override
  List<Object?> get props => [profile, badges, leaderboard, activeTab];
}

class RewardsError extends RewardsState {
  final String message;

  const RewardsError(this.message);

  @override
  List<Object?> get props => [message];
}
