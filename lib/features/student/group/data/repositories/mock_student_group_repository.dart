import 'package:elara/core/error/failures.dart';
import 'package:elara/core/network/api_result.dart';
import 'package:elara/features/student/group/domain/entities/group_announcement.dart';
import 'package:elara/features/student/group/domain/entities/group_leaderboard_entry.dart';
import 'package:elara/features/student/group/domain/entities/group_roadmap.dart';
import 'package:elara/features/student/group/domain/entities/student_group_overview.dart';
import 'package:elara/features/student/group/domain/repositories/student_group_repository.dart';

class MockStudentGroupRepository implements StudentGroupRepository {
  @override
  Future<ApiResult<StudentGroupOverview>> getGroupOverview({
    required String groupId,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    return ApiResult.success(
      const StudentGroupOverview(
        courseTitle: 'Physics 101',
        courseSubtitle: 'Science • Grade 7',
        completedLessons: 8,
        totalLessons: 18,
      ),
    );
  }

  @override
  Future<ApiResult<List<GroupLeaderboardEntry>>> getLeaderboard({
    required String groupId,
  }) async {
    try {
      await Future<void>.delayed(const Duration(milliseconds: 450));

      return ApiResult.success(<GroupLeaderboardEntry>[
        const GroupLeaderboardEntry(
          rank: 1,
          memberName: 'Emma S.',
          points: 3240,
          completedLessons: 14,
          totalLessons: 18,
          isCurrentUser: false,
        ),
        const GroupLeaderboardEntry(
          rank: 2,
          memberName: 'Liam K.',
          points: 2890,
          completedLessons: 14,
          totalLessons: 18,
          isCurrentUser: false,
        ),
        const GroupLeaderboardEntry(
          rank: 3,
          memberName: 'Olivia M.',
          points: 2650,
          completedLessons: 9,
          totalLessons: 18,
          isCurrentUser: false,
        ),
        const GroupLeaderboardEntry(
          rank: 4,
          memberName: 'You',
          points: 1250,
          completedLessons: 9,
          totalLessons: 18,
          isCurrentUser: true,
        ),
        const GroupLeaderboardEntry(
          rank: 5,
          memberName: 'Noah J.',
          points: 1180,
          completedLessons: 5,
          totalLessons: 18,
          isCurrentUser: false,
        ),
      ]);
    } catch (_) {
      return ApiResult.failure(
        const UnknownFailure('Failed to load leaderboard'),
      );
    }
  }

  @override
  Future<ApiResult<GroupRoadmap>> getRoadmap({required String groupId}) async {
    await Future<void>.delayed(const Duration(milliseconds: 350));
    return ApiResult.success(
      GroupRoadmap.fromModules(const [
        GroupRoadmapModule(
          moduleLabel: 'MODULE 01',
          title: 'Introduction to Waves',
          description: 'Oscillations, amplitude, and frequency basics.',
          status: RoadmapModuleStatus.completed,
        ),
        GroupRoadmapModule(
          moduleLabel: 'MODULE 02',
          title: 'Kinematics',
          description: 'Motion in one and two dimensions.',
          status: RoadmapModuleStatus.inProgress,
        ),
        GroupRoadmapModule(
          moduleLabel: 'MODULE 03',
          title: 'Dynamics',
          description: "Newton's laws and force interactions.",
          status: RoadmapModuleStatus.locked,
        ),
      ], completedFraction: 0.45),
    );
  }

  @override
  Future<ApiResult<List<GroupAnnouncement>>> getAnnouncements({
    required String groupId,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return ApiResult.success(const [
      GroupAnnouncement(
        id: 'ann-1',
        title: 'Final Exam Venue Change',
        body:
            'Please note that the final exam will now be held in Room 204 '
            '(East Wing) instead of the lecture hall. Please arrive 15 '
            'minutes early for seating.',
        relativeTimeLabel: '2 hours ago',
      ),
      GroupAnnouncement(
        id: 'ann-2',
        title: 'Lab Reports Extended',
        body:
            'The deadline for Lab Report #3 has been extended to Friday at '
            '5 PM due to equipment maintenance issues in Lab B this week.',
        relativeTimeLabel: 'Yesterday',
      ),
    ]);
  }
}
