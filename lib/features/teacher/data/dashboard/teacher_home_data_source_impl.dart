import 'package:dio/dio.dart';
import 'package:elara/features/teacher/domain/entities/teacher_dashboard_entity.dart';
import 'package:flutter/material.dart';
import 'package:elara/core/constants/api_constants.dart';
import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/features/teacher/data/datasources/teacher_home_data_source.dart';
import 'package:elara/features/teacher/domain/entities/teacher_activity_entity.dart';
import 'package:elara/features/teacher/domain/entities/teacher_group_entity.dart';
import 'package:elara/features/teacher/domain/entities/teacher_profile_entity.dart';
import 'package:elara/features/teacher/domain/entities/teacher_roadmap_entity.dart';
import 'package:elara/features/teacher/data/models/teacher_roadmap_model.dart';

/// Mock implementation of [TeacherHomeDataSource].
///
/// Returns hardcoded data so the UI is fully testable without a backend.
///  : Replace with a real HTTP implementation when the API is ready.
class TeacherHomeDataSourceImpl implements TeacherHomeDataSource {
  final Dio _dio;

  TeacherHomeDataSourceImpl(this._dio);

  Map<String, dynamic>? _homeCache;
  DateTime? _lastFetch;
  Future<Map<String, dynamic>>? _fetchFuture;

  Future<Map<String, dynamic>> _fetchHome() {
    final now = DateTime.now();
    if (_homeCache != null &&
        _lastFetch != null &&
        now.difference(_lastFetch!) < const Duration(seconds: 2)) {
      return Future.value(_homeCache!);
    }

    if (_fetchFuture != null) {
      return _fetchFuture!;
    }

    _fetchFuture = _dio
        .get(ApiConstants.teacherHome)
        .then((response) {
          final responseData = response.data;
          if (responseData is Map<String, dynamic> &&
              responseData.containsKey('data')) {
            _homeCache = responseData['data'] as Map<String, dynamic>;
          } else {
            _homeCache = responseData;
          }
          _lastFetch = DateTime.now();
          _fetchFuture = null;
          return _homeCache!;
        })
        .catchError((error) {
          _fetchFuture = null;
          throw error;
        });

    return _fetchFuture!;
  }

  @override
  Future<TeacherDashboardEntity> getDashboard() async {
    final data = await _fetchHome();

    // 1. Parse Profile
    final firstName =
        data['firstName']?.toString() ??
        data['FirstName']?.toString() ??
        'Teacher';
    final stats =
        (data['stats'] ?? data['Stats']) as Map<String, dynamic>? ?? {};
    final activeStudents =
        (stats['activeStudents'] ?? stats['ActiveStudents'])
            as Map<String, dynamic>? ??
        {};
    final avgCompletion =
        (stats['avgCompletion'] ?? stats['AvgCompletion'])
            as Map<String, dynamic>? ??
        {};
    final groupsRaw = (data['groups'] ?? data['Groups']) as List? ?? [];
    final profile = TeacherProfileEntity(
      id: 'teacher-1',
      firstName: firstName,
      lastName: '',
      groupCount: groupsRaw.length,
      activeStudentCount:
          (activeStudents['count'] ?? activeStudents['Count'] as num?)
              ?.toInt() ??
          0,
      avgCompletion:
          (avgCompletion['percentage'] ?? avgCompletion['Percentage'] as num?)
              ?.toDouble() ??
          0.0,
    );

    // 2. Parse Groups
    final groupsList = (data['groups'] ?? data['Groups']) as List? ?? [];
    final groups = groupsList.map((g) {
      final map = g as Map<String, dynamic>;
      return TeacherGroupEntity(
        id: map['id']?.toString() ?? map['Id']?.toString() ?? '',
        name:
            map['name']?.toString() ??
            map['Name']?.toString() ??
            'Unnamed Group',
        subject: map['subject']?.toString() ?? map['Subject']?.toString() ?? '',
        grade: map['grade']?.toString() ?? map['Grade']?.toString() ?? '1',
        studentCount:
            (map['studentsCount'] ?? map['StudentsCount'] as num?)?.toInt() ??
            0,
        totalLessons: 0,
        progressPercent: 0.0,
        colorKey: 'primary',
      );
    }).toList();

    // 3. Parse Roadmaps
    final roadmapsList = (data['roadmaps'] ?? data['Roadmaps']) as List? ?? [];
    final roadmaps = roadmapsList.map((r) {
      final map = r as Map<String, dynamic>;
      return TeacherGroupEntity(
        id: map['id']?.toString() ?? map['Id']?.toString() ?? '',
        name:
            map['title']?.toString() ??
            map['Title']?.toString() ??
            'Unnamed Roadmap',
        subject: map['subject']?.toString() ?? map['Subject']?.toString() ?? '',
        grade: map['grade']?.toString() ?? map['Grade']?.toString() ?? '1',
        studentCount: 0,
        totalLessons:
            (map['lessonsCount'] ?? map['LessonsCount'] as num?)?.toInt() ?? 0,
        progressPercent: 0.0,
        colorKey: 'secondary',
      );
    }).toList();

    // 4. Parse Activity
    final activityList =
        (data['recentActivity'] ?? data['RecentActivity']) as List? ?? [];
    final recentActivity = activityList.asMap().entries.map((entry) {
      final index = entry.key;
      final map = entry.value as Map<String, dynamic>;
      final type = map['type']?.toString() ?? map['Type']?.toString() ?? '';
      final student =
          (map['student'] ?? map['Student']) as Map<String, dynamic>? ?? {};
      final studentName =
          student['name']?.toString() ??
          student['Name']?.toString() ??
          student['username']?.toString() ??
          student['Username']?.toString() ??
          'Student';

      String title = '$studentName did something';
      String subtitle =
          map['targetId']?.toString() ?? map['TargetId']?.toString() ?? '';
      String iconAsset = 'assets/icons/alerts_icon_filled.svg';
      Color iconColor = AppColors.brandPrimary500;

      if (type.contains('submit') ||
          type.contains('homework') ||
          type.contains('Submit') ||
          type.contains('Homework')) {
        title = '$studentName submitted homework';
        iconAsset = 'assets/icons/book_icon.svg';
      } else if (type.contains('quiz') || type.contains('Quiz')) {
        title = '$studentName completed a quiz';
        iconAsset = 'assets/icons/graduation_cap_icon.svg';
        iconColor = AppColors.brandSecondary500;
      } else if (type.contains('join') || type.contains('Join')) {
        title = '$studentName joined your group';
        iconAsset = 'assets/icons/people_outline.svg';
        iconColor = AppColors.success500;
      }

      return TeacherActivityEntity(
        id: 'activity_$index',
        title: title,
        subtitle: subtitle,
        timeAgo:
            map['date']?.toString() ?? map['Date']?.toString() ?? 'Just now',
        iconAsset: iconAsset,
        iconColor: iconColor,
      );
    }).toList();

    return TeacherDashboardEntity(
      profile: profile,
      groups: groups,
      roadmaps: roadmaps,
      recentActivity: recentActivity,
    );
  }

  @override
  Future<List<TeacherGroupEntity>> getGroups() async {
    final response = await _dio.get(ApiConstants.teacherGroups);
    final responseData = response.data;

    final groupsList =
        (responseData is Map<String, dynamic> &&
            responseData.containsKey('data'))
        ? responseData['data'] as List<dynamic>? ?? []
        : (responseData is List ? responseData : []);

    return groupsList.map((g) {
      final map = g as Map<String, dynamic>;
      return TeacherGroupEntity(
        id: map['id']?.toString() ?? map['Id']?.toString() ?? '',
        name:
            map['name']?.toString() ??
            map['Name']?.toString() ??
            'Unnamed Group',
        subject: map['subject']?.toString() ?? map['Subject']?.toString() ?? '',
        grade: map['grade']?.toString() ?? map['Grade']?.toString() ?? '1',
        studentCount:
            (map['studentsCount'] ?? map['StudentsCount'] as num?)?.toInt() ??
            0,
        totalLessons:
            (map['totalLessons'] ?? map['TotalLessons'] as num?)?.toInt() ?? 0,
        progressPercent:
            (map['progressPercent'] ?? map['ProgressPercent'] as num?)
                ?.toDouble() ??
            0.0,
        colorKey: 'primary',
      );
    }).toList();
  }

  @override
  Future<List<TeacherGroupEntity>> getRoadmaps() async {
    final response = await _dio.get(ApiConstants.teacherRoadmaps);
    final responseData = response.data;

    final roadmapsList =
        (responseData is Map<String, dynamic> &&
            responseData.containsKey('data'))
        ? responseData['data'] as List<dynamic>? ?? []
        : (responseData is List ? responseData : []);

    return roadmapsList.map((r) {
      final map = r as Map<String, dynamic>;
      return TeacherGroupEntity(
        id: map['id']?.toString() ?? map['Id']?.toString() ?? '',
        name:
            map['name']?.toString() ??
            map['Name']?.toString() ??
            'Unnamed Roadmap',
        subject: map['subject']?.toString() ?? map['Subject']?.toString() ?? '',
        grade: map['grade']?.toString() ?? map['Grade']?.toString() ?? '1',
        studentCount: 0,
        totalLessons:
            (map['modulesCount'] ?? map['ModulesCount'] as num?)?.toInt() ?? 0,
        progressPercent: 0.0,
        colorKey: 'secondary',
      );
    }).toList();
  }

  @override
  Future<TeacherRoadmapEntity> getRoadmapDetails(String id) async {
    final response = await _dio.get(ApiConstants.teacherRoadmapInfo(id));
    final responseData = response.data;

    if (responseData is Map<String, dynamic> && responseData.containsKey('data')) {
      return TeacherRoadmapModel.fromJson(responseData['data'] as Map<String, dynamic>);
    }
    
    return TeacherRoadmapModel.fromJson(responseData as Map<String, dynamic>);
  }

  @override
  Future<void> createGroup({
    required String title,
    required String subject,
    required String grade,
    required String roadmapName,
  }) async {
    // Extract integer from "Grade 10" string
    final gradeInt = int.tryParse(grade.replaceAll(RegExp(r'[^0-9]'), '')) ?? 1;

    final requestData = {
      'name': title,
      'grade': gradeInt,
      'subject': subject,
      'roadmapName': roadmapName,
    };

    await _dio.post(ApiConstants.teacherGroups, data: requestData);
  }

  @override
  Future<void> createRoadmap({
    required String title,
    required String subject,
    required String grade,
  }) async {
    final gradeInt = int.tryParse(grade.replaceAll(RegExp(r'[^0-9]'), '')) ?? 1;

    final requestData = {'name': title, 'grade': gradeInt, 'subject': subject};

    await _dio.post(ApiConstants.teacherRoadmaps, data: requestData);
  }
}
