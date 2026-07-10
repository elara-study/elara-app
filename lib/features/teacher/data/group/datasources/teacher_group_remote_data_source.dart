import 'package:dio/dio.dart';
import 'package:elara/core/constants/api_constants.dart';
import 'package:elara/features/student/domain/group/entities/group_announcement.dart';
import 'package:elara/features/teacher/data/group/datasources/teacher_group_data_source.dart';
import 'package:elara/features/teacher/data/group/models/teacher_group_model.dart';
import 'package:elara/features/teacher/domain/group/entities/teacher_roadmap_entity.dart';
import 'package:elara/features/teacher/data/group/models/teacher_roadmap_model.dart';
import 'package:elara/features/teacher/domain/group/entities/teacher_student_insight_entity.dart';
import 'package:elara/features/teacher/data/group/models/teacher_student_insight_model.dart';
import 'package:elara/features/teacher/domain/group/entities/teacher_group_detail_entity.dart';
import 'package:elara/features/teacher/domain/group/entities/teacher_student_entity.dart';
import 'package:elara/features/teacher/domain/group/entities/teacher_student_profile_entity.dart';
import 'package:elara/features/student/domain/profile/entities/profile_linked_parent_entity.dart';
import 'package:intl/intl.dart';

class TeacherGroupRemoteDataSourceImpl implements TeacherGroupDataSource {
  final Dio _dio;

  const TeacherGroupRemoteDataSourceImpl(this._dio);

  @override
  Future<TeacherGroupModel> createGroup({
    required String name,
    required int grade,
    required String subject,
    String? roadmap,
  }) async {
    final response = await _dio.post(
      ApiConstants.teacherGroups,
      data: {
        'name': name,
        'grade': grade,
        'subject': subject,
        if (roadmap != null) 'roadmap': roadmap,
      },
    );
    return TeacherGroupModel.fromJson(response.data);
  }

  @override
  Future<void> deleteGroup(String groupId) async {
    await _dio.delete(ApiConstants.teacherGroupInfo(groupId));
  }

  @override
  Future<TeacherGroupDetailEntity> getGroupDetail(String groupId) async {
    Response? infoResponse;
    Response? studentsResponse;

    try {
      final responses = await Future.wait([
        _dio.get(ApiConstants.teacherGroupInfo(groupId)),
        _dio.get(ApiConstants.teacherGroupStudents(groupId)),
      ]);
      infoResponse = responses[0];
      studentsResponse = responses[1];
    } catch (e) {
      rethrow;
    }

    final infoResponseDataRaw =
        infoResponse.data as Map<String, dynamic>? ?? {};
    final infoResponseData = infoResponseDataRaw.containsKey('data')
        ? infoResponseDataRaw['data'] as Map<String, dynamic>
        : infoResponseDataRaw;

    final data = infoResponseData.containsKey('group')
        ? infoResponseData['group'] as Map<String, dynamic>
        : infoResponseData;

    final studentsResponseData = studentsResponse.data;

    List<dynamic> studentsListRaw = [];
    int totalLessons = 0;

    final studentsDataToParse =
        studentsResponseData is Map<String, dynamic> &&
            studentsResponseData.containsKey('data')
        ? studentsResponseData['data']
        : studentsResponseData;

    if (studentsDataToParse is List) {
      studentsListRaw = studentsDataToParse;
    } else if (studentsDataToParse is Map<String, dynamic>) {
      totalLessons =
          int.tryParse(studentsDataToParse['totalLessons']?.toString() ?? '') ??
          0;
      studentsListRaw =
          studentsDataToParse['data'] as List<dynamic>? ??
          studentsDataToParse['students'] as List<dynamic>? ??
          [];
    }

    final List<TeacherStudentEntity> students = studentsListRaw
        .asMap()
        .entries
        .map((entry) {
          final index = entry.key;
          final s = entry.value as Map<String, dynamic>;

          // Try to extract name from nested user object if it exists
          final userObj = s['user'] as Map<String, dynamic>?;
          final studentName =
              userObj?['name']?.toString() ??
              userObj?['username']?.toString() ??
              s['name']?.toString() ??
              'Unknown Student';

          return TeacherStudentEntity(
            id: s['id']?.toString() ?? 'unknown_$index',
            rank: index + 1,
            name: studentName,
            xp: int.tryParse(s['xp']?.toString() ?? '') ?? 0,
            streak: int.tryParse(s['streak']?.toString() ?? '') ?? 0,
            avatarUrl:
                s['imageUrl']?.toString() ??
                s['avatar']?.toString() ??
                userObj?['avatar']?.toString(),
            completedLessons:
                int.tryParse(s['currentLesson']?.toString() ?? '') ?? 0,
            totalLessons: totalLessons,
          );
        })
        .toList();

    final double avgCompletion = students.isEmpty
        ? 0.0
        : students.fold<double>(0.0, (sum, s) => sum + s.progress) /
              students.length;
    return TeacherGroupDetailEntity(
      name:
          data['name']?.toString() ??
          data['Name']?.toString() ??
          'Unknown Group',
      subject: data['subject']?.toString() ?? data['Subject']?.toString() ?? '',
      grade:
          int.tryParse(
            data['grade']?.toString() ?? data['Grade']?.toString() ?? '',
          ) ??
          1,
      joinCode:
          data['joinCode']?.toString() ?? data['JoinCode']?.toString() ?? '',
      studentCount: students.length,
      avgCompletion: avgCompletion,
      presentToday: 0,
      students: students,
    );
  }

  @override
  Future<TeacherStudentProfileEntity> getStudentProfile({
    required String groupId,
    required int studentRank,
  }) async {
    final group = await getGroupDetail(groupId);
    final student = group.students.firstWhere(
      (s) => s.rank == studentRank,
      orElse: () => group.students.first,
    );

    final response = await _dio.get(
      ApiConstants.teacherStudentInfo(student.id),
    );
    final responseData = response.data['data'] as Map<String, dynamic>? ?? {};

    final userMap = responseData['user'] as Map<String, dynamic>? ?? {};
    final gamification =
        responseData['gamification'] as Map<String, dynamic>? ?? {};
    final stats = responseData['stats'] as Map<String, dynamic>? ?? {};
    final parentsList = responseData['parents'] as List<dynamic>? ?? [];

    final username =
        userMap['username']?.toString() ??
        student.name.replaceAll(RegExp(r'[^a-zA-Z]'), '').toLowerCase();
    final handle = '@${username.isEmpty ? 'student' : username}';
    final gradeLabel =
        userMap['gradeLevel']?.toString() ?? 'Grade ${group.grade} Student';

    final attendanceRate =
        double.tryParse(stats['attendanceRate']?.toString() ?? '0') ?? 0;

    return TeacherStudentProfileEntity(
      student: TeacherStudentEntity(
        id: student.id,
        rank: student.rank,
        name: userMap['fullName']?.toString() ?? student.name,
        xp: int.tryParse(stats['totalXp']?.toString() ?? '') ?? student.xp,
        streak:
            int.tryParse(stats['streakDays']?.toString() ?? '') ??
            student.streak,
        avatarUrl: userMap['avatarUrl']?.toString() ?? student.avatarUrl,
        completedLessons:
            int.tryParse(stats['lessonsCompleted']?.toString() ?? '') ??
            student.completedLessons,
        totalLessons:
            int.tryParse(stats['totalLessons']?.toString() ?? '') ??
            student.totalLessons,
      ),
      handle: handle,
      gradeLabel: gradeLabel,
      level: gamification['currentLevel'] as int? ?? 1,
      nextLevel: (gamification['currentLevel'] as int? ?? 1) + 1,
      xpCurrent: gamification['currentXp'] as int? ?? 0,
      xpGoal: gamification['nextLevelXpThreshold'] as int? ?? 100,
      streakDays: stats['streakDays'] as int? ?? 0,
      attendancePercent: (attendanceRate * 100).toInt(),
      parents: parentsList.map((p) {
        final pMap = p as Map<String, dynamic>;
        return ProfileLinkedParentEntity(
          id: pMap['id']?.toString() ?? '',
          displayName:
              pMap['fullName']?.toString() ?? pMap['name']?.toString() ?? '',
        );
      }).toList(),
      insight: TeacherStudentInsightModel.fromJson(response.data),
    );
  }

  @override
  Future<void> addStudent({
    required String groupId,
    required String username,
  }) async {
    await _dio.post(
      ApiConstants.teacherGroupStudents(groupId),
      data: {'username': username},
    );
  }

  @override
  Future<List<GroupAnnouncement>> getAnnouncements(String groupId) async {
    final response = await _dio.get(
      ApiConstants.teacherGroupAnnouncements(groupId),
    );
    final responseDataRaw = response.data as Map<String, dynamic>? ?? {};

    // Unwrap standard response format
    final dataContent = responseDataRaw.containsKey('data')
        ? responseDataRaw['data']
        : responseDataRaw;

    final data = (dataContent is List)
        ? dataContent
        : (dataContent is Map<String, dynamic>
              ? (dataContent['announcements'] as List<dynamic>? ?? [])
              : []);

    return data.asMap().entries.map((entry) {
      final index = entry.key;
      final a = entry.value as Map<String, dynamic>;

      // We parse the date into a relative format or pass as-is
      // Backend provides title and date. GroupAnnouncement expects body as well.
      // We map date to relativeTimeLabel and empty string for body.
      final dateStr = a['createdAt']?.toString() ?? a['date']?.toString();
      String timeLabel = 'Unknown Date';
      if (dateStr != null) {
        try {
          final dt = DateTime.parse(dateStr).toLocal();
          timeLabel = DateFormat.yMMMd().add_jm().format(dt);
        } catch (_) {
          timeLabel = dateStr;
        }
      }

      return GroupAnnouncement(
        id: a['id']?.toString() ?? 'announcement_$index',
        title: a['title']?.toString() ?? 'No Title',
        content: a['content']?.toString() ?? '',
        relativeTimeLabel: timeLabel,
      );
    }).toList();
  }

  @override
  Future<void> addAnnouncement(
    String groupId,
    String title,
    String content,
  ) async {
    await _dio.post(
      ApiConstants.teacherGroupAnnouncements(groupId),
      data: {'title': title, 'content': content},
    );
  }

  @override
  Future<void> deleteAnnouncement(String groupId, String announcementId) async {
    await _dio.delete(
      ApiConstants.teacherGroupDeleteAnnouncement(groupId, announcementId),
    );
  }

  @override
  Future<TeacherRoadmapEntity> getRoadmap(String groupId) async {
    final response = await _dio.get(ApiConstants.teacherGroupRoadmap(groupId));
    return TeacherRoadmapModel.fromJson(response.data);
  }

  @override
  Future<void> deleteRoadmap(String roadmapId) async {
    await _dio.delete(ApiConstants.teacherRoadmapInfo(roadmapId));
  }

  @override
  Future<TeacherStudentInsightEntity?> getStudentInsights(
    String studentId,
  ) async {
    try {
      final response = await _dio.get(
        ApiConstants.teacherStudentInfo(studentId),
      );
      return TeacherStudentInsightModel.fromJson(response.data);
    } catch (e) {
      return null;
    }
  }
}
