import 'package:elara/core/constants/api_constants.dart';
import 'package:elara/core/error/failures.dart';
import 'package:elara/core/network/api_result.dart';
import 'package:elara/core/network/dio_client.dart';
import 'package:elara/features/student/domain/group/entities/group_announcement.dart';
import 'package:elara/features/student/domain/group/entities/group_leaderboard_entry.dart';
import 'package:elara/features/student/domain/group/entities/group_roadmap.dart';
import 'package:elara/features/student/domain/group/entities/student_group_overview.dart';
import 'package:elara/features/student/domain/group/repositories/student_group_repository.dart';

class StudentGroupRepositoryImpl implements StudentGroupRepository {
  final DioClient _dioClient;

  StudentGroupRepositoryImpl({required DioClient dioClient})
    : _dioClient = dioClient;

  /// Safely converts a JSON value that may be [num] or [String] to [int].
  static int _parseInt(dynamic value, int fallback) {
    if (value == null) return fallback;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? fallback;
    return fallback;
  }

  @override
  Future<ApiResult<StudentGroupOverview>> getGroupOverview({
    required String groupId,
  }) async {
    try {
      final response = await _dioClient.dio.get(
        ApiConstants.studentLearnGroupOverview(groupId),
      );

      // Response shape:
      // { "data": { "group": { "name", "subject", "grade" },
      //             "progress": { "currentLesson", "totalLessons" } } }
      final data = response.data['data'] as Map<String, dynamic>;
      final group = data['group'] as Map<String, dynamic>;
      final progress = data['progress'] as Map<String, dynamic>;

      final name = group['name'] as String? ?? '';
      final subject = group['subject'] as String? ?? '';
      final grade = group['grade']; // int or String
      final gradeStr = grade != null ? 'Grade $grade' : '';

      // courseTitle  → group name  (e.g. "Physics A")
      // courseSubtitle → subject • grade (e.g. "Physics - 3rd Secondary • Grade 12")
      final subtitle = gradeStr.isNotEmpty ? '$subject • $gradeStr' : subject;

      final completedLessons = _parseInt(progress['currentLesson'], 0);
      final totalLessons = _parseInt(progress['totalLessons'], 1);

      return ApiResult.success(
        StudentGroupOverview(
          groupId: groupId,
          courseTitle: name,
          courseSubtitle: subtitle,
          completedLessons: completedLessons,
          totalLessons: totalLessons > 0 ? totalLessons : 1,
        ),
      );
    } catch (e) {
      return ApiResult.failure(ServerFailure(e.toString()));
    }
  }

  @override
  Future<ApiResult<List<GroupLeaderboardEntry>>> getLeaderboard({
    required String groupId,
  }) async {
    // No backend endpoint yet — return static UI mock data.
    return ApiResult.success(const <GroupLeaderboardEntry>[
      GroupLeaderboardEntry(
        rank: 1,
        memberName: 'Emma S.',
        points: 3240,
        completedLessons: 14,
        totalLessons: 20,
        isCurrentUser: false,
      ),
      GroupLeaderboardEntry(
        rank: 2,
        memberName: 'Liam K.',
        points: 2890,
        completedLessons: 14,
        totalLessons: 20,
        isCurrentUser: false,
      ),
      GroupLeaderboardEntry(
        rank: 3,
        memberName: 'Olivia M.',
        points: 2650,
        completedLessons: 9,
        totalLessons: 20,
        isCurrentUser: false,
      ),
      GroupLeaderboardEntry(
        rank: 4,
        memberName: 'You',
        points: 1250,
        completedLessons: 9,
        totalLessons: 20,
        isCurrentUser: true,
      ),
      GroupLeaderboardEntry(
        rank: 5,
        memberName: 'Noah J.',
        points: 1180,
        completedLessons: 5,
        totalLessons: 20,
        isCurrentUser: false,
      ),
    ]);
  }

  @override
  Future<ApiResult<GroupRoadmap>> getRoadmap({required String groupId}) async {
    try {
      final response = await _dioClient.dio.get(
        'api/v1/student/groups/$groupId/modules',
      );
      final data = response.data['data'] as Map<String, dynamic>;
      final modulesJson = data['modules'] as List<dynamic>;

      final modules = <GroupRoadmapModule>[];
      for (var i = 0; i < modulesJson.length; i++) {
        final m = modulesJson[i] as Map<String, dynamic>;

        // First module is inProgress, rest are locked
        final status = i == 0
            ? RoadmapModuleStatus.inProgress
            : RoadmapModuleStatus.locked;

        // Derive label from index
        final indexLabel = (i + 1).toString().padLeft(2, '0');

        // 'id' is a UUID string — store it as moduleId for quiz generation.
        modules.add(
          GroupRoadmapModule(
            moduleLabel: 'MODULE $indexLabel',
            title: m['title'] as String? ?? 'Untitled Module',
            description: m['description'] as String? ?? '',
            status: status,
            moduleId: m['id'] as String?,
            lessonId: i + 1,
          ),
        );
      }

      // We don't have completedFraction from this new API structure, so default to 0.0 or calculate
      return ApiResult.success(
        GroupRoadmap.fromModules(modules, completedFraction: 0.0),
      );
    } catch (e) {
      return ApiResult.failure(ServerFailure(e.toString()));
    }
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
        content:
            'Please note that the final exam will now be held in Room 204 '
            '(East Wing) instead of the lecture hall. Please arrive 15 '
            'minutes early for seating.',
        relativeTimeLabel: '2 hours ago',
      ),
      GroupAnnouncement(
        id: 'ann-2',
        title: 'Lab Reports Extended',
        content:
            'The deadline for Lab Report #3 has been extended to Friday at '
            '5 PM due to equipment maintenance issues in Lab B this week.',
        relativeTimeLabel: 'Yesterday',
      ),
    ]);
  }
}
