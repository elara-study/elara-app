import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/features/teacher/data/datasources/teacher_home_data_source.dart';
import 'package:elara/features/teacher/domain/entities/teacher_activity_entity.dart';
import 'package:elara/features/teacher/domain/entities/teacher_group_entity.dart';
import 'package:elara/features/teacher/domain/entities/teacher_profile_entity.dart';

/// Mock implementation of [TeacherHomeDataSource].
///
/// Returns hardcoded data so the UI is fully testable without a backend.
/// TODO: Replace with a real HTTP implementation when the API is ready.
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
    return const [
      TeacherGroupEntity(
        id: 'g-1',
        name: 'Physics — Grade 10A',
        subject: 'Physics',
        studentCount: 28,
        progressPercent: 0.68,
        colorKey: 'purple',
      ),
      TeacherGroupEntity(
        id: 'g-2',
        name: 'Chemistry — Grade 11B',
        subject: 'Chemistry',
        studentCount: 24,
        progressPercent: 0.45,
        colorKey: 'orange',
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
}
