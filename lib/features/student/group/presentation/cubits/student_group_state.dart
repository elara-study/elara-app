part of 'student_group_cubit.dart';

class StudentGroupState extends Equatable {
  final StudentGroupStatus status;
  final StudentGroupOverview? overview;
  final List<GroupLeaderboardEntry> leaderboard;
  final String? message;
  final Failure? failure;

  const StudentGroupState._({
    required this.status,
    this.overview,
    this.leaderboard = const [],
    this.message,
    this.failure,
  });

  const StudentGroupState.initial()
    : this._(status: StudentGroupStatus.initial);

  const StudentGroupState.loading()
    : this._(status: StudentGroupStatus.loading);

  const StudentGroupState.loaded({
    required StudentGroupOverview overview,
    required List<GroupLeaderboardEntry> leaderboard,
  }) : this._(
         status: StudentGroupStatus.loaded,
         overview: overview,
         leaderboard: leaderboard,
       );

  const StudentGroupState.failure({required String message, Failure? failure})
    : this._(
        status: StudentGroupStatus.failure,
        message: message,
        failure: failure,
      );

  @override
  List<Object?> get props => [status, overview, leaderboard, message, failure];
}

enum StudentGroupStatus { initial, loading, loaded, failure }
