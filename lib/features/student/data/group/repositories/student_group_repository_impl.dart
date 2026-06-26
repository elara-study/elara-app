import 'package:dio/dio.dart';
import 'package:elara/core/constants/api_constants.dart';
import 'package:elara/core/error/failures.dart';
import 'package:elara/core/network/api_result.dart';
import 'package:elara/core/network/dio_client.dart';
import 'package:elara/features/student/domain/group/entities/group_announcement.dart';
import 'package:elara/features/student/domain/group/entities/group_leaderboard_entry.dart';
import 'package:elara/features/student/domain/group/entities/group_roadmap.dart';
import 'package:elara/features/student/domain/group/entities/student_group_overview.dart';
import 'package:elara/features/student/domain/group/repositories/student_group_repository.dart';

/// Real network implementation of [StudentGroupRepository].
///
/// Replaces [MockStudentGroupRepository] in production.
/// Returns [ApiResult] — never throws — so cubits can safely call `.fold()`.
class StudentGroupRepositoryImpl implements StudentGroupRepository {
  final DioClient _dioClient;

  StudentGroupRepositoryImpl({required DioClient dioClient})
      : _dioClient = dioClient;

  // Group Overview
  @override
  Future<ApiResult<StudentGroupOverview>> getGroupOverview({
    required String groupId,
  }) async {
    try {
      final response = await _dioClient.dio.get(
        ApiConstants.studentGroupById(groupId),
      );
      final data = response.data['data'] as Map<String, dynamic>? ?? {};
      final group = data['group'] as Map<String, dynamic>? ?? {};
      final progress = data['progress'] as Map<String, dynamic>? ?? {};

      final name = group['name'] as String? ?? '';
      final subject = (group['subject'] as String? ?? '').toUpperCase();
      final grade = group['grade'];
      final subtitle = '$subject • Grade $grade';
      final currentLesson = progress['currentLesson'] as int? ?? 0;
      final totalLessons = progress['totalLessons'] as int? ?? 0;

      return ApiResult.success(
        StudentGroupOverview(
          courseTitle: name,
          courseSubtitle: subtitle,
          completedLessons: currentLesson,
          totalLessons: totalLessons,
        ),
      );
    } on DioException catch (e) {
      final msg = e.response?.data?['message'] as String? ??
          e.message ??
          'Failed to load group overview';
      return ApiResult.failure(ServerFailure(msg));
    } catch (e) {
      return ApiResult.failure(ServerFailure(e.toString()));
    }
  }

  // Leaderboard — mocked (no student endpoint yet)
  @override
  Future<ApiResult<List<GroupLeaderboardEntry>>> getLeaderboard({
    required String groupId,
  }) async {
    // TODO: replace with real endpoint when available
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
  }

  // Roadmap (modules)
  @override
  Future<ApiResult<GroupRoadmap>> getRoadmap({required String groupId}) async {
    try {
      final response = await _dioClient.dio.get(
        ApiConstants.studentGroupModules(groupId),
      );
      final data = response.data['data'] as Map<String, dynamic>? ?? {};
      final rawModules =
          (data['modules'] as List<dynamic>? ?? <dynamic>[])
              .cast<Map<String, dynamic>>();

      // The API does not include a per-module status field.
      // Until a progress endpoint is available we assign:
      //   • first module  → inProgress
      //   • rest          → locked
      final modules = rawModules.asMap().entries.map((entry) {
        final index = entry.key;
        final m = entry.value;
        final label =
            'MODULE ${(index + 1).toString().padLeft(2, '0')}';
        final status = index == 0
            ? RoadmapModuleStatus.inProgress
            : RoadmapModuleStatus.locked;
        return GroupRoadmapModule(
          moduleLabel: label,
          title: m['title'] as String? ?? '',
          description: m['description'] as String? ?? '',
          status: status,
        );
      }).toList();

      return ApiResult.success(
        GroupRoadmap.fromModules(modules, completedFraction: 0),
      );
    } on DioException catch (e) {
      final msg = e.response?.data?['message'] as String? ??
          e.message ??
          'Failed to load roadmap';
      return ApiResult.failure(ServerFailure(msg));
    } catch (e) {
      return ApiResult.failure(ServerFailure(e.toString()));
    }
  }

  // Announcements — mocked (no student endpoint yet)
  @override
  Future<ApiResult<List<GroupAnnouncement>>> getAnnouncements({
    required String groupId,
  }) async {
    // TODO: replace with real student endpoint when available
    return ApiResult.success(<GroupAnnouncement>[
      const GroupAnnouncement(
        id: 'ann-1',
        title: 'Final Exam Venue Change',
        body:
            'Please note that the final exam will now be held in Room 204 '
            '(East Wing) instead of the lecture hall. Please arrive 15 '
            'minutes early for seating.',
        relativeTimeLabel: '2 hours ago',
      ),
      const GroupAnnouncement(
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
