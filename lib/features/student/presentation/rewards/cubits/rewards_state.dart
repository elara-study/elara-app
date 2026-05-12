import 'package:elara/features/student/domain/rewards/entities/badge_entity.dart';
import 'package:elara/features/student/domain/rewards/entities/leaderboard_entry_entity.dart';
import 'package:elara/features/student/domain/rewards/entities/rewards_profile_entity.dart';
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

  const RewardsLoaded({
    required this.profile,
    required this.badges,
    required this.leaderboard,
  });

  @override
  List<Object?> get props => [profile, badges, leaderboard];
}

class RewardsError extends RewardsState {
  final String message;

  const RewardsError(this.message);

  @override
  List<Object?> get props => [message];
}
