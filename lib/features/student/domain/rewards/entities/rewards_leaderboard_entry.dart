import 'package:equatable/equatable.dart';

class RewardsLeaderboardEntry extends Equatable {
  final int rank;
  final String displayName;
  final int points;

  const RewardsLeaderboardEntry({
    required this.rank,
    required this.displayName,
    required this.points,
  });

  factory RewardsLeaderboardEntry.fromJson(Map<String, dynamic> json) {
    final rankRaw = json['rank'] ?? json['position'] ?? 0;
    final rank = rankRaw is int
        ? rankRaw
        : int.tryParse(rankRaw.toString()) ?? 0;
    final name =
        json['display_name']?.toString() ??
        json['displayName']?.toString() ??
        json['name']?.toString() ??
        '';
    final ptsRaw = json['points'] ?? json['score'] ?? 0;
    final pts = ptsRaw is int ? ptsRaw : int.tryParse(ptsRaw.toString()) ?? 0;
    return RewardsLeaderboardEntry(rank: rank, displayName: name, points: pts);
  }

  @override
  List<Object?> get props => [rank, displayName, points];
}
