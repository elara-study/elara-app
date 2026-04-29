import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/features/teacher/data/datasources/teacher_home_data_source.dart';
import 'package:elara/features/teacher/domain/entities/teacher_activity_entity.dart';
import 'package:elara/features/teacher/domain/entities/teacher_group_entity.dart';
import 'package:elara/features/teacher/domain/entities/teacher_profile_entity.dart';

/// Mock implementation of [TeacherHomeDataSource].
///
/// Returns hardcoded data so the UI is fully testable without a backend.
///  : Replace with a real HTTP implementation when the API is ready.
class TeacherHomeDataSourceImpl implements TeacherHomeDataSource {
  const TeacherHomeDataSourceImpl();

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
    await Future.delayed(const Duration(milliseconds: 400));
    return [
      TeacherGroupEntity(
        id: 'g-1',
        name: 'Physics — Grade 10A',
        subject: 'Physics',
        grade: 'Grade 10',
        studentCount: 28,
        totalLessons: 32,
        progressPercent: 0.68,
        colorKey: 'purple',
      ),
      TeacherGroupEntity(
        id: 'g-2',
        name: 'Chemistry — Grade 11B',
        subject: 'Chemistry',
        grade: 'Grade 11',
        studentCount: 24,
        totalLessons: 28,
        progressPercent: 0.45,
        colorKey: 'orange',
      ),
      TeacherGroupEntity(
        id: 'g-3',
        name: 'Biology — Grade 9C',
        subject: 'Biology',
        grade: 'Grade 9',
        studentCount: 31,
        totalLessons: 24,
        progressPercent: 0.82,
        colorKey: 'green',
      ),
      TeacherGroupEntity(
        id: 'g-4',
        name: 'Physics — Grade 11A',
        subject: 'Physics',
        grade: 'Grade 11',
        studentCount: 22,
        totalLessons: 32,
        progressPercent: 0.33,
        colorKey: 'purple',
      ),
    ];
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
    // Mock implementation — replace with real API call when backend is ready
    await Future.delayed(const Duration(milliseconds: 500));
    // In a real implementation, this would:
    // 1. Send a POST request to the backend
    // 2. Handle validation and error responses
    // 3. Return the created group data
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
