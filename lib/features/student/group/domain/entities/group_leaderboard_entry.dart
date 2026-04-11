import 'package:equatable/equatable.dart';

class GroupLeaderboardEntry extends Equatable {
  final int rank;
  final String memberName;
  final int points;

  /// Completed lesson count for display (e.g. "Lesson 8 of 18").
  final int completedLessons;

  /// Total lessons in the course for this group.
  final int totalLessons;
  final bool isCurrentUser;

  const GroupLeaderboardEntry({
    required this.rank,
    required this.memberName,
    required this.points,
    required this.completedLessons,
    required this.totalLessons,
    required this.isCurrentUser,
  });

  /// 0..1, derived from lesson counts.
  double get progress =>
      totalLessons == 0 ? 0.0 : completedLessons / totalLessons;

  @override
  List<Object> get props => [
    rank,
    memberName,
    points,
    completedLessons,
    totalLessons,
    isCurrentUser,
  ];
}
