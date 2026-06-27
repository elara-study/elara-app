import 'package:dio/dio.dart';
import 'package:elara/core/constants/api_constants.dart';
import 'package:elara/features/teacher/group/data/datasources/teacher_group_data_source.dart';
import 'package:elara/features/teacher/group/data/models/teacher_group_model.dart';
import 'package:elara/features/student/domain/group/entities/group_announcement.dart';
import 'package:elara/features/teacher/group/domain/entities/teacher_group_detail_entity.dart';
import 'package:elara/features/teacher/group/domain/entities/teacher_student_entity.dart';
import 'package:elara/features/teacher/group/domain/entities/teacher_student_profile_entity.dart';

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
      if (e is DioException) {
        final req = e.requestOptions;
        print('=== INVESTIGATION LOG ===');
        print('Request URI: ${req.uri}');
        print('Request Method: ${req.method}');
        print('Response Status Code: ${e.response?.statusCode}');
        print('Response Data: ${e.response?.data}');
        print('=============================');
      }
      rethrow;
    }

    final data = infoResponse.data['group'] as Map<String, dynamic>? ?? {};
    final studentsData = studentsResponse.data as Map<String, dynamic>? ?? {};

    final totalLessons = int.tryParse(studentsData['totalLessons']?.toString() ?? '') ?? 0;
    final studentsListRaw = studentsData['data'] as List<dynamic>? ?? [];

    final List<TeacherStudentEntity> students = studentsListRaw.asMap().entries.map((entry) {
      final index = entry.key;
      final s = entry.value as Map<String, dynamic>;
      return TeacherStudentEntity(
        id: s['id']?.toString() ?? 'unknown_$index',
        rank: index + 1,
        name: s['name']?.toString() ?? 'Unknown Student',
        xp: int.tryParse(s['xp']?.toString() ?? '') ?? 0,
        streak: int.tryParse(s['streak']?.toString() ?? '') ?? 0,
        avatarUrl: s['imageUrl']?.toString() ?? s['avatar']?.toString(),
        completedLessons: int.tryParse(s['currentLesson']?.toString() ?? '') ?? 0,
        totalLessons: totalLessons,
      );
    }).toList();

    final double avgCompletion = students.isEmpty
        ? 0.0
        : students.fold<double>(0.0, (sum, s) => sum + s.progress) / students.length;

    return TeacherGroupDetailEntity(
      name: data['name']?.toString() ?? 'Unknown Group',
      subject: data['subject']?.toString() ?? 'Unknown Subject',
      grade: int.tryParse(data['grade']?.toString() ?? '') ?? 1,
      joinCode: data['joinCode']?.toString() ?? '',
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
  }) {
    throw UnimplementedError('API endpoint not ready');
  }
  @override
  Future<List<GroupAnnouncement>> getAnnouncements(String groupId) async {
    final response = await _dio.get(ApiConstants.teacherGroupAnnouncements(groupId));
    final data = response.data['announcements'] as List<dynamic>? ?? [];

    return data.asMap().entries.map((entry) {
      final index = entry.key;
      final a = entry.value as Map<String, dynamic>;
      
      // We parse the date into a relative format or pass as-is
      // Backend provides title and date. GroupAnnouncement expects body as well.
      // We map date to relativeTimeLabel and empty string for body.
      return GroupAnnouncement(
        id: a['id']?.toString() ?? 'announcement_$index',
        title: a['title']?.toString() ?? 'No Title',
        body: a['body']?.toString() ?? '', 
        relativeTimeLabel: a['date']?.toString() ?? 'Unknown Date',
      );
    }).toList();
  }
}
