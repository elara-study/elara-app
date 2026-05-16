import 'package:equatable/equatable.dart';

/// A single entry in the class leaderboard.
///
/// [isCurrentUser] is true for the row that represents the logged-in student,
/// which is rendered with a highlighted card background.
class LeaderboardEntryEntity extends Equatable {
  final int rank;
  final String name;
  final int xp;
  final bool isCurrentUser;

  const LeaderboardEntryEntity({
    required this.rank,
    required this.name,
    required this.xp,
    this.isCurrentUser = false,
  });

  @override
  List<Object?> get props => [rank, name, xp, isCurrentUser];
}
