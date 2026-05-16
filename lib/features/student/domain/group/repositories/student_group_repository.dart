import 'package:elara/core/network/api_result.dart';
import 'package:elara/features/student/domain/group/entities/group_announcement.dart';
import 'package:elara/features/student/domain/group/entities/group_leaderboard_entry.dart';
import 'package:elara/features/student/domain/group/entities/group_roadmap.dart';
import 'package:elara/features/student/domain/group/entities/student_group_overview.dart';

abstract class StudentGroupRepository {
  Future<ApiResult<StudentGroupOverview>> getGroupOverview({
    required String groupId,
  });

  Future<ApiResult<List<GroupLeaderboardEntry>>> getLeaderboard({
    required String groupId,
  });

  Future<ApiResult<GroupRoadmap>> getRoadmap({required String groupId});

  Future<ApiResult<List<GroupAnnouncement>>> getAnnouncements({
    required String groupId,
  });
}
