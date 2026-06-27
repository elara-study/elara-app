import 'package:dio/dio.dart';
import 'package:elara/core/constants/api_constants.dart';
import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/features/teacher/data/datasources/teacher_home_data_source.dart';
import 'package:elara/features/teacher/domain/entities/teacher_activity_entity.dart';
import 'package:elara/features/teacher/domain/entities/teacher_group_entity.dart';
import 'package:elara/features/teacher/data/models/teacher_group_model.dart';
import 'package:elara/features/teacher/domain/entities/teacher_profile_entity.dart';

/// Mock implementation of [TeacherHomeDataSource].
///
/// Returns hardcoded data so the UI is fully testable without a backend.
///  : Replace with a real HTTP implementation when the API is ready.
class TeacherHomeDataSourceImpl implements TeacherHomeDataSource {
  final Dio _dio;

  const TeacherHomeDataSourceImpl(this._dio);

  @override
  Future<TeacherProfileEntity> getProfile() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return const TeacherProfileEntity(
      id: 'teacher-1',
      firstName: 'Sarah',
      lastName: 'Johnson',
      groupCount: 4,
      activeStudentCount: 87,
      avgCompletion: 0.72,
    );
  }

  @override
  Future<List<TeacherGroupEntity>> getGroups() async {
    final response = await _dio.get(ApiConstants.teacherGroups);
    final data = response.data;
    
    List<dynamic> groupsList = [];
    
    if (data is List) {
      groupsList = data;
    } else if (data != null && data is Map) {
      if (data['groups'] != null) {
        groupsList = data['groups'] as List;
      } else if (data['data'] != null) {
        groupsList = data['data'] as List;
      }
    }

    return groupsList
        .map((g) => TeacherGroupModel.fromJson(g as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<TeacherActivityEntity>> getRecentActivity() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return const [
      TeacherActivityEntity(
        id: 'a-1',
        title: 'Ali Hassan submitted homework',
        subtitle: 'Physics • Chapter 3',
        timeAgo: '2 min ago',
        iconAsset: 'assets/icons/book_icon.svg',
        iconColor: AppColors.brandPrimary500,
      ),
      TeacherActivityEntity(
        id: 'a-2',
        title: 'Nour Khalil completed a quiz',
        subtitle: 'Chemistry • Unit 2',
        timeAgo: '15 min ago',
        iconAsset: 'assets/icons/graduation_cap_icon.svg',
        iconColor: AppColors.brandSecondary500,
      ),
      TeacherActivityEntity(
        id: 'a-3',
        title: 'Karim Saad joined your group',
        subtitle: 'Physics — Grade 10A',
        timeAgo: '1 hr ago',
        iconAsset: 'assets/icons/people_outline.svg',
        iconColor: AppColors.success500,
      ),
    ];
  }

  @override
  Future<void> createGroup({
    required String title,
    required String subject,
    required String grade,
  }) async {
    // Extract integer from "Grade 10" string
    final gradeInt = int.tryParse(grade.replaceAll(RegExp(r'[^0-9]'), '')) ?? 1;

    await _dio.post(
      ApiConstants.teacherGroups,
      data: {
        'name': title,
        'grade': gradeInt,
        'subject': subject,
      },
    );
  }

  @override
  Future<void> createRoadmap({
    required String title,
    required String subject,
    required String grade,
  }) async {
    // Mock implementation — replace with real API call when backend is ready
    await Future.delayed(const Duration(milliseconds: 500));
    // In a real implementation, this would:
    // 1. Send a POST request to the backend
    // 2. Handle validation and error responses
    // 3. Return the created roadmap data
  }
}
