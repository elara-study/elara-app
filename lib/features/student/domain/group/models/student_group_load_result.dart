import 'package:elara/features/student/domain/group/entities/group_leaderboard_entry.dart';
import 'package:elara/features/student/domain/group/entities/student_group_overview.dart';

/// Aggregate returned by [LoadStudentGroupUseCase].
class StudentGroupLoadResult {
  final StudentGroupOverview overview;
  final List<GroupLeaderboardEntry> leaderboard;

  const StudentGroupLoadResult({
    required this.overview,
    required this.leaderboard,
  });
}
